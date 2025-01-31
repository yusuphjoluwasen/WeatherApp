//
// WeatherReducer.swift
// WeatherApp
//
// Created by Guru King on 08/07/2024.
//

import Foundation
import ComposableArchitecture

/// `SearchHistory`: A reducer for managing the search history feature in the WeatherApp.
///
/// This reducer handles actions related to the search query, fetching weather data, loading search history, and navigating to weather details.
@Reducer
struct SearchHistory {
    /// State: The state of the search history view.
    ///
    /// - Properties:
    ///   - searches: An array of previous searches.
    ///   - searchQuery: The current search query string.
    ///   - isLoading: A boolean indicating if data is currently being loaded.
    ///   - error: An optional string containing any error message.
    ///   - weatherDetail: An optional state for the weather detail view.
    @ObservableState
    struct State: Equatable {
        var searches: [Search] = []
        var searchQuery = ""
        var isLoading = false
        var error: String?
        @Presents var weatherDetail: WeatherDetail.State?
    }
    
    /// Action: The actions that can be performed on the search list state.
    enum Action {
        case searchItemTapped(String)
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchSuccessResponse(WeatherResponse)
        case searchErrorResponse(String)
        case loadSearchHistory
        case searchHistoryLoaded([Search])
        case stopLoadingAndResetQuery
        case navigateToDetail(WeatherDetailModel)
        case weatherDetail(PresentationAction<WeatherDetail.Action>)
        case dismissErrorAlert
    }
    
    /// Identifiers for cancellable operations, used to manage the lifecycle of asynchronous tasks.
    private enum CancelID { case fetch }
    
    /// Dependencies for the reducer, including clients for fetching weather data and managing search data.
    @Dependency(\.weatherClient) var weatherClient
    @Dependency(\.searchDataManager) var searchDataManager
    
    /// The body of the reducer, containing the logic for handling each action and updating the state accordingly.
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchItemTapped(city):
                state.searchQuery = city
                return .run { send in
                    await send(.searchQueryChanged(city))
                    await send(.searchQueryChangeDebounced)
                }
                
            case let .searchQueryChanged(query):
                state.searchQuery = query
                return .none
                
            case .searchQueryChangeDebounced:
                
                guard !state.searchQuery.isTrimmedEmpty else {
                    return .none
                }
                state.isLoading = true
                return .run { [searchQuery = state.searchQuery] send in
                    /// Fetch weather data from the weather client
                    let data = try await weatherClient.forecast(location: searchQuery)
                    await send(.searchSuccessResponse(data))
                } catch: { error, send in
                    /// Handle error and send searchErrorResponse action
                    await send(.searchErrorResponse("Failed to fetch data: \(error.localizedDescription)"))
                }
                    .cancellable(id: CancelID.fetch)
                
            case let .searchSuccessResponse(weatherResponse):
                /// Handle successful weather data response, map it to a Search object, and save it to Core Data
                if let search = weatherResponse.toSearch(with: state.searchQuery) {
                    do {
                        try searchDataManager.saveOrUpdateSearch(search)
                        return .merge(
                            .send(.loadSearchHistory),
                            .send(.navigateToDetail(weatherResponse.toWeatherDetailDomainModel(location: state.searchQuery))),
                            .send(.stopLoadingAndResetQuery)
                        )
                    } catch {
                        return .send(.searchErrorResponse("Failed to save data: \(error.localizedDescription)"))
                    }
                }
                return .none
                
            case let .searchErrorResponse(errorString):
                /// Handle error response and update the state with the error message
                state.isLoading = false
                state.error = errorString
                return .none
                
            case .loadSearchHistory:
                /// Load search history from Core Data
                do {
                    let result = try searchDataManager.fetchCitySearches()
                    return .send(.searchHistoryLoaded(result))
                } catch {
                    // Handle error and send searchErrorResponse action
                    return .send(.searchErrorResponse("Failed to fetch data: \(error.localizedDescription)"))
                }
                
            case let .searchHistoryLoaded(searches):
                /// Update the state with the loaded search history
                state.searches = searches
                return .none
                
            case .stopLoadingAndResetQuery:
                /// Stop loading and reset the search query
                state.isLoading = false
                state.searchQuery = ""
                return .none
                
            case .weatherDetail:
                return .none
                
            case let .navigateToDetail(data):
                state.weatherDetail = WeatherDetail.State(weatherDetail: data)
                return .none
                
            case .dismissErrorAlert:
                state.error = nil
                return .none
            }
        }
        .ifLet(\.$weatherDetail, action: \.weatherDetail) {
            WeatherDetail()
        }
    }
}
