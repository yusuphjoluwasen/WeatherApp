//
//  SearchModel.swift
//  WeatherApp
//
//  Created by Guru King on 08/07/2024.
//

import Foundation
import Utilities

/// A structure representing a search result containing weather details.
///
/// The `Search` structure contains details such as the city name, current temperature,
/// a brief description of the weather, and an icon representing the weather condition.
/// It also includes an array of forecasts for different times.
///
struct Search: Equatable, Identifiable {
    let id: UUID
    let time: String
    let city: String
    let weatherCode: Int
    let temperature: String
    let temperatureApparent: String
    let forecasts: [Forecast]
    
    /// A computed property that returns a human-readable description of the weather based on the weather code.
    var weatherDescription: String {
        return weatherInfo(for: weatherCode).description
    }
    
    /// A computed property that returns the name of the weather icon based on the weather code.
    var weatherIconName: String {
        return weatherInfo(for: weatherCode).iconName
    }
}

extension Search {
    /// Mock data for preview purposes.
    static let mock = Search(
        id: UUID(),
        time: "2024-07-09T11:49:00Z".formatDate(to: .fullDateWithTime).toString,
        city: "New York",
        weatherCode: 1001,
        temperature: "20.19".toCelcius,
        temperatureApparent: "20.19".toCelcius,
        forecasts: [Forecast.mock, Forecast.mock]
    )
}

/// A structure representing a weather forecast for a specific time.
///
/// The `Forecast` structure contains details such as the time, temperature,
/// and an icon representing the weather condition at that time.
///

struct Forecast: Equatable, Identifiable {
    let id: UUID
    let weatherCode: Int
    let temperature: String
    let time: String
    
    /// A computed property that returns a human-readable description of the weather based on the weather code.
    var weatherDescription: String {
        return weatherInfo(for: weatherCode).description
    }
    
    /// A computed property that returns the name of the weather icon based on the weather code.
    var weatherIconName: String {
        return weatherInfo(for: weatherCode).iconName
    }
}

extension Forecast {
    /// Mock data for preview purposes.
    static let mock = Forecast(
        id: UUID(),
        weatherCode: 1001,
        temperature: "20.19".toCelcius,
        time: "2024-07-09T11:49:00Z".formatDate(to: .hour).toString
    )
    
    static let mocks: [Forecast] = [
        .mock,
        Forecast(id: UUID(), weatherCode: 1002, temperature: "20.5", time: ("2024-07-09T12:00:00Z".formatDate(to: .hour)).toString),
        Forecast(id: UUID(), weatherCode: 1003, temperature: "21.0", time: ("2024-07-09T12:10:00Z".formatDate(to: .hour)).toString)
    ]
}
