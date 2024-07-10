//
//  ForecastListView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

import SwiftUI

/// ForecastListView: A view that displays a list of forecast items.
///
/// This view takes an array of `Forecast` objects and displays each one in a horizontal list.
/// Each forecast item shows the time, temperature, and a corresponding weather icon.
///
/// Example usage:
/// ```swift
/// ForecastListView(forecasts: [Forecast.mock, Forecast.mock])
/// ```
struct ForecastListView: View {
    /// The list of forecast objects containing weather details.
    let forecasts: [Forecast]
    
    var body: some View {
        LazyHStack {
            ForEach(forecasts) { item in
                ForecastItemView(forecast: item)
                    .padding(.trailing)
                
                if item.id != forecasts.last?.id {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ForecastListView(forecasts: [Forecast.mock, Forecast.mock])
}
