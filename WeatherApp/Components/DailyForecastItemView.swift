//
//  DailyForecastItemView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// DailyForecastItemView: A view that displays a single daily forecast item with time, temperature range, and weather icon.
///
/// This view takes a `DailyForecast` object which contains weather details for a specific day.
/// It displays the day, maximum and minimum temperatures, and a corresponding weather icon.
struct DailyForecastItemView: View {
    /// The daily forecast object containing weather details for a specific day.
    let forecast: DailyForecast

    var body: some View {
        HStack {
            Text(forecast.time)
                .font(.system(.caption, weight: .bold))
                .padding(.trailing)
            Image(forecast.weatherIconName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.trailing)
            Text("Min: \(forecast.temperatureMin)")
                .font(.caption)
                .padding(.trailing)
            Text("Max: \(forecast.temperatureMax)")
                .font(.caption)
                .padding(.leading)
           
        }
        .padding()
    }
}

#Preview {
    DailyForecastItemView(forecast: DailyForecast.mock)
}
