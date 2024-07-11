//
//  CurrentWeatherDetailView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// CurrentWeatherView: A view that displays the current weather information.
///
/// This view takes a `WeatherDetailDomainModel` object and displays the city name, current temperature, and weather icon.
struct CurrentWeatherView: View {
    /// The weather detail object containing the current weather information.
    let weatherDetail: WeatherDetailModel
    
    // MARK: - UI Rendering
    
    var body: some View {
        VStack {
            Text(weatherDetail.city)
                .font(.title2)
            Text(weatherDetail.temperature)
                .font(.largeTitle)
            Image(weatherDetail.weatherIconName)
        }
        .padding()
    }
}

#Preview {
    CurrentWeatherView(weatherDetail: .mock)
}
