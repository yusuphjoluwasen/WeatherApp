//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import ComposableArchitecture

/// WeatherDetail: A reducer that manages the state and actions related to weather details and historical forecasts.
///
/// This reducer handles the fetching and updating of weather details, including current, hourly, daily, and historical forecasts.
@Reducer
struct WeatherDetail {
    
    /// State: The state of the weather detail view.
    ///
    /// - Properties:
    ///   - weatherDetail: The current weather details.
    ///   - isLoadingHistorical: A boolean indicating if historical data is being loaded.
    ///   - hourlyHistory: An array of hourly historical forecasts.
    ///   - dailyHistory: An array of daily historical forecasts.
    ///   - error: An optional error message.
    @ObservableState
    struct State: Equatable {
        var weatherDetail: WeatherDetailModel
        var isLoadingHistorical: Bool = false
        var hourlyHistory: [Forecast] = []
        var dailyHistory: [DailyForecast] = []
        var error: String?
    }
    
    /// Action: The actions that can be performed on the weather detail state.
    ///
    /// - Cases:
    ///   - fetchHistoricalForecasts: Triggers the fetching of historical forecasts.
    ///   - updateHistoricalForecasts: Updates the state with the fetched historical forecasts.
    ///   - successResponse: Handles a successful response from the weather client.
    ///   - errorResponse: Handles an error response.
    enum Action {
        case fetchHistoricalForecasts
        case updateHistoricalForecasts(WeatherResponse)
        case successResponse(WeatherResponse)
        case errorResponse(String)
    }
    
    /// Dependencies: The dependencies required by the reducer, including the weather client for fetching data.
    @Dependency(\.weatherClient) var weatherClient
    
    /// The body of the reducer, containing the logic for handling each action and updating the state accordingly.
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchHistoricalForecasts:
                /// Fetch historical forecasts for the specified location.
                state.isLoadingHistorical = true
                return .run { [location = state.weatherDetail.city] send in
                    let result = try await weatherClient.history(location: location)
                    await send(.successResponse(result))
                } catch: { error, send in
                    /// Handle error and send errorResponse action.
                    return await send(.errorResponse("Failed to fetch data: \(error.localizedDescription)"))
                }
                
            case let .successResponse(result):
                /// Handle successful response and update the state with the historical forecasts.
                state.isLoadingHistorical = false
                return .send(.updateHistoricalForecasts(result))
            
            case let .errorResponse(errorString):
                /// Handle error response and update the state with the error message.
                state.isLoadingHistorical = false
                state.error = errorString
                return .none

            case let .updateHistoricalForecasts(response):
                /// Update the state with the fetched historical forecasts.
                state.hourlyHistory = response.toHourlyForecasts()
                state.dailyHistory = response.toDailyForecasts()
                return .none
            }
        }
    }
}
