//
//  WeatherDetailModel.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation
import Utilities

struct WeatherDetailModel:Equatable, Identifiable {
    let id: UUID
    let time:String
    let city: String
    let weatherCode: Int
    let temperature: String
    let minutely: [Forecast]
    let hourly: [Forecast]
    let daily: [DailyForecast]
    
    /// A computed property that returns a human-readable description of the weather based on the weather code.
    var weatherDescription: String {
        return weatherInfo(for: weatherCode).description
    }
    
    /// A computed property that returns the name of the weather icon based on the weather code.
    var weatherIconName: String {
        return weatherInfo(for: weatherCode).iconName
    }
}

struct DailyForecast: Equatable, Identifiable {
    let id: UUID
    let time: String
    let temperatureMax: String
    let temperatureMin: String
    let weatherCode: Int
    
    /// A computed property that returns a human-readable description of the weather based on the weather code.
    var weatherDescription: String {
        return weatherInfo(for: weatherCode).description
    }
    
    /// A computed property that returns the name of the weather icon based on the weather code.
    var weatherIconName: String {
        return weatherInfo(for: weatherCode).iconName
    }
}

///weather detail mock data for testing
extension WeatherDetailModel {
    static let mock = WeatherDetailModel(
        id: UUID(),
        time: ("2024-07-09T11:49:00Z".formatDate(to: .fullDateWithTime)).toString,
        city: "New York",
        weatherCode: 1001,
        temperature: "20.19".toCelcius,
        minutely: Forecast.mocks,
        hourly: Forecast.mocks,
        daily: DailyForecast.mocks
    )
}

extension DailyForecast {
    static let mock = DailyForecast(
        id: UUID(),
        time: ("2024-07-09T00:00:00Z".formatDate(to: .dayOfWeekShort)).toString,
        temperatureMax: "25.0",
        temperatureMin: "18.0",
        weatherCode: 1001
    )
    
    static let mocks: [DailyForecast] = [
        .mock,
        DailyForecast(id: UUID(), time: ("2024-07-10T00:00:00Z".formatDate(to: .dayOfWeekShort)).toString, temperatureMax: "26.0", temperatureMin: "19.0", weatherCode: 1002),
        DailyForecast(id: UUID(), time: ("2024-07-11T00:00:00Z".formatDate(to: .dayOfWeekShort)).toString, temperatureMax: "27.0", temperatureMin: "20.0", weatherCode: 1003)
    ]
}




