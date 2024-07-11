//
//  WeatherDetailTest.swift
//  WeatherAppTests
//
//  Created by Guru King on 11/07/2024.
//

import XCTest
import ComposableArchitecture
@testable import WeatherApp

/// WeatherDetailTests: A test suite for the WeatherDetail reducer.
///
/// This test suite ensures that the WeatherDetail reducer correctly handles various actions related to fetching and updating weather details,
/// including handling success and error responses, managing loading states, and updating historical forecasts.

final class WeatherDetailTests: XCTestCase {
    
    // Tests that the WeatherDetail feature initializes with the expected mock data.
    ///
    /// This test verifies that the initial state of the WeatherDetail feature is correctly set up with mock data.
    /// It initializes the TestStore with the mock data and asserts that the initial state matches the expected values.
    @MainActor
    func testInitialWeatherDetailState() async {
        let store = TestStore(initialState: WeatherDetail.State(weatherDetail: .mock)) {
            WeatherDetail()
        }
        
        XCTAssertEqual(store.state.weatherDetail.city, "New York")
        XCTAssertEqual(store.state.weatherDetail.temperature, "20.19°C")
        XCTAssertEqual(store.state.weatherDetail.weatherCode, 1001)
        XCTAssertEqual(store.state.weatherDetail.weatherIconName, "cloudy")
        XCTAssertEqual(store.state.weatherDetail.weatherDescription, "Cloudy")
        XCTAssertEqual(store.state.weatherDetail.daily.count, 3)
        XCTAssertEqual(store.state.weatherDetail.minutely.count, 3)
        XCTAssertEqual(store.state.weatherDetail.hourly.count, 3)
    }
    
    /// Tests that the WeatherDetail feature initializes with the expected hourly data.
       ///
       /// This test verifies that the initial state of the WeatherDetail feature is correctly set up with mock hourly data.
       /// It initializes the TestStore with the mock data and asserts that the hourly data matches the expected values.
       @MainActor
       func testInitialWeatherDetailHourlyData() async {
           let store = TestStore(initialState: WeatherDetail.State(weatherDetail: .mock)) {
               WeatherDetail()
           }

           XCTAssertEqual(store.state.weatherDetail.hourly[0].temperature, "20.19°C")
           XCTAssertEqual(store.state.weatherDetail.hourly[1].temperature, "20.5")
           XCTAssertEqual(store.state.weatherDetail.hourly[2].temperature, "21.0")

           XCTAssertEqual(store.state.weatherDetail.hourly.first?.temperature, "20.19°C")
           XCTAssertEqual(store.state.weatherDetail.hourly.first?.time, "12 PM")
           XCTAssertEqual(store.state.weatherDetail.hourly.first?.weatherCode, 1001)
           XCTAssertEqual(store.state.weatherDetail.hourly.first?.weatherIconName, "cloudy")
           XCTAssertEqual(store.state.weatherDetail.hourly.first?.weatherDescription, "Cloudy")
       }
    
    /// Tests that the WeatherDetail feature initializes with the expected minutely data.
    ///
    /// This test verifies that the initial state of the WeatherDetail feature is correctly set up with mock minutely data.
    /// It initializes the TestStore with the mock data and asserts that the minutely data matches the expected values.
    @MainActor
    func testInitialWeatherDetailMinutelyData() async {
        let store = TestStore(initialState: WeatherDetail.State(weatherDetail: .mock)) {
            WeatherDetail()
        }
        
        XCTAssertEqual(store.state.weatherDetail.minutely[0].temperature, "20.19°C")
        XCTAssertEqual(store.state.weatherDetail.minutely[1].temperature, "20.5")
        XCTAssertEqual(store.state.weatherDetail.minutely[2].temperature, "21.0")

        XCTAssertEqual(store.state.weatherDetail.minutely.first?.temperature, "20.19°C")
        XCTAssertEqual(store.state.weatherDetail.minutely.first?.time, "12 PM")
        XCTAssertEqual(store.state.weatherDetail.minutely.first?.weatherCode, 1001)
        XCTAssertEqual(store.state.weatherDetail.minutely.first?.weatherIconName, "cloudy")
        XCTAssertEqual(store.state.weatherDetail.minutely.first?.weatherDescription, "Cloudy")
    }
    
    /// Tests that the fetchHistoricalForecasts action successfully fetches historical forecasts and updates the state.
    ///
    /// This test mocks a successful response from the weather client, sends the fetchHistoricalForecasts action, and verifies that the state
    /// is updated with the fetched historical forecasts and the loading state is correctly managed.
    @MainActor
    func testFetchHistoricalForecastsSuccess() async {
        let store = TestStore(initialState: WeatherDetail.State(weatherDetail: .mock)) {
            WeatherDetail()
        } withDependencies: {
            $0.weatherClient.history = { _ in .mock }
        }
        
        store.exhaustivity = .off
        
        await store.send(.fetchHistoricalForecasts) {
            $0.isLoadingHistorical = true
        }
        
        await store.receive(\.successResponse) {
            $0.isLoadingHistorical = false
        }
        
        await store.receive(\.updateHistoricalForecasts) {
            $0.isLoadingHistorical = false
            
            ///Assert for daily data
            XCTAssertEqual($0.dailyHistory.count, 1)
            XCTAssertEqual($0.dailyHistory.first?.temperatureMax, "23.0°C")
            XCTAssertEqual($0.dailyHistory.first?.temperatureMin, "21.0°C")
            XCTAssertEqual($0.dailyHistory.first?.time, "Tue")
            XCTAssertEqual($0.dailyHistory.first?.weatherCode, 1001)
            XCTAssertEqual($0.dailyHistory.first?.weatherIconName, "cloudy")
            XCTAssertEqual($0.dailyHistory.first?.weatherDescription, "Cloudy")
            
            ///Assert for hourly data
            XCTAssertEqual($0.hourlyHistory.count, 1)
            XCTAssertEqual($0.hourlyHistory.first?.temperature, "21.0°C")
            XCTAssertEqual($0.hourlyHistory.first?.time, "1 PM")
            XCTAssertEqual($0.hourlyHistory.first?.weatherCode, 1001)
            XCTAssertEqual($0.hourlyHistory.first?.weatherIconName, "cloudy")
            XCTAssertEqual($0.hourlyHistory.first?.weatherDescription, "Cloudy")
        }
    }
    
    /// Tests that the fetchHistoricalForecasts action handles errors correctly.
    ///
    /// This test mocks a failure response from the weather client, sends the fetchHistoricalForecasts action, and verifies that the state
    /// is updated with the error message and the loading state is correctly managed.
    @MainActor
    func testFetchHistoricalForecastsFailure() async {
        struct TestError: Error, Equatable {}
        
        let store = TestStore(initialState: WeatherDetail.State(weatherDetail: .mock)) {
            WeatherDetail()
        } withDependencies: {
            $0.weatherClient.history = { _ in throw TestError() }
        }
        
        await store.send(.fetchHistoricalForecasts) {
            $0.isLoadingHistorical = true
        }
        
        await store.receive(\.errorResponse) {
            $0.isLoadingHistorical = false
            $0.error = "Failed to fetch data: \(TestError().localizedDescription)"
        }
    }

}
