//
//  WeatherServiceTest.swift
//  WeatherAppTests
//
//  Created by Guru King on 10/07/2024.
//

import XCTest
import ComposableArchitecture
import Networking
@testable import WeatherApp


final class SearchListTests: XCTestCase {
    
    @MainActor
    func testSearchQueryChanged() async {
        let store = TestStore(initialState: SearchHistory.State()) {
            SearchHistory()
        }

        await store.send(.searchQueryChanged("New York")) {
            $0.searchQuery = "New York"
        }
    }
    
    @MainActor
    func testFetchForecastSuccess() async {
        let store = TestStore(initialState: SearchHistory.State(searchQuery: "New York")) {
            SearchHistory()
            
        } withDependencies: {
            $0.weatherClient.forecast = { _ in .mock }
        }
        
        store.exhaustivity = .off

        await store.send(.searchQueryChangeDebounced) {
            $0.isLoading = true
        }

        await store.receive(\.searchSuccessResponse) {
                $0.searchQuery = "New York"
                $0.searches = []
                $0.isLoading = true
        }

        await store.receive(\.loadSearchHistory){ state in
                state.searchQuery = "New York"
                state.searches = []
                state.isLoading = true
        }
        
        await store.receive(\.navigateToDetail){ state in
           
                state.searchQuery = "New York"
                state.searches = []
                state.isLoading = true
        }
        
        await store.receive(\.stopLoadingAndResetQuery) {
            $0.isLoading = false
            $0.searchQuery = ""
        }
       
        await store.receive(\.searchHistoryLoaded){ state in

                state.searchQuery = ""
                state.searches =  [Search.mock]
                state.isLoading = false
        }
    }
    
    @MainActor
    func testFetchForecastFailure() async {
    
        let store = TestStore(initialState: SearchHistory.State(searchQuery: "New York")) {
            SearchHistory()
        } withDependencies: {
            $0.weatherClient.forecast = { _ in throw NetworkServiceError.invalidURL}
        }

        await store.send(.searchQueryChangeDebounced) {
            $0.isLoading = true
        }

        await store.receive(\.searchErrorResponse) {
            $0.isLoading = false
            $0.error = "Failed to fetch data: Invalid URL encountered. Can\'t proceed with the request"
        }
    }
    
    @MainActor
    func testLoadSearchHistory() async {
          let mockSearches = [
            Search.mock,
            Search.mock
          ]
  
          let store = TestStore(initialState: SearchHistory.State()) {
              SearchHistory()
          } withDependencies: {
              $0.searchDataManager.saveOrUpdateSearch = { _ in }
              $0.searchDataManager.fetchCitySearches = { return mockSearches }
          }
  
          await store.send(.loadSearchHistory)
  
          await store.receive(\.searchHistoryLoaded) {
              $0.searches = mockSearches
          }
      }

}
