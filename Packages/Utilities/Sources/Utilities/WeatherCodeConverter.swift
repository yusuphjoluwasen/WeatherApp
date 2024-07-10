//
//  WeatherCodeConverter.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation

/// Returns a tuple containing the weather description and the icon name based on the given weather code.
/// - Parameter code: The weather code value.
/// - Returns: A tuple with the weather description and the icon name.
func weatherInfo(for code: Int) -> (description: String, iconName: String) {
    let weatherData: [Int: (String, String)] = [
        0: ("Unknown", "unknown"),
        1000: ("Clear", "clear_day"),
        1001: ("Cloudy", "cloudy"),
        1100: ("Mostly Clear", "mostly_clear_day"),
        1101: ("Partly Cloudy", "partly_cloudy_day"),
        1102: ("Mostly Cloudy", "mostly_cloudy"),
        2000: ("Fog", "fog"),
        2100: ("Light Fog", "fog_light"),
        4000: ("Drizzle", "drizzle"),
        4001: ("Rain", "rain"),
        4200: ("Light Rain", "rain_light"),
        4201: ("Heavy Rain", "rain_heavy"),
        5000: ("Snow", "snow"),
        5001: ("Flurries", "flurries"),
        5100: ("Light Snow", "snow_light"),
        5101: ("Heavy Snow", "snow_heavy"),
        6000: ("Freezing Drizzle", "freezing_drizzle"),
        6001: ("Freezing Rain", "freezing_rain"),
        6200: ("Light Freezing Rain", "freezing_rain_light"),
        6201: ("Heavy Freezing Rain", "freezing_rain_heavy"),
        7000: ("Ice Pellets", "ice_pellets"),
        7101: ("Heavy Ice Pellets", "ice_pellets_heavy"),
        7102: ("Light Ice Pellets", "ice_pellets_light"),
        8000: ("Thunderstorm", "tstorm")
    ]
    
    return weatherData[code, default: ("Unknown", "unknown")]
}

