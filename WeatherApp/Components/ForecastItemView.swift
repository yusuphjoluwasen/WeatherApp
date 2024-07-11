//
//  ForecastItemView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// ForecastItemView: A view that displays a single forecast item with time, temperature, and weather icon.
///
/// This view takes a `Forecast` object which contains weather details for a specific time.
/// It displays the time, temperature, and a corresponding weather icon.
///
struct ForecastItemView: View {
    /// The forecast object containing weather details for a specific time.
    let forecast: Forecast
    
    // MARK: - UI Rendering
    
    var body: some View {
        VStack {
            Text(forecast.time)
                .font(.system(.caption2, weight: .bold))
            
            Image(forecast.weatherIconName)
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(forecast.temperature)
                .font(.system(.caption2))
        }
    }
}

#Preview {
    ForecastItemView(forecast: Forecast.mock)
}
