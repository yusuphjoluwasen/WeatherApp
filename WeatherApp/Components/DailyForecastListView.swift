//
//  DailyForecastListView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// DailyForecastListView: A view that displays a list of daily forecast items.
///
/// This view takes an array of `DailyForecast` objects and displays each one using the `DailyForecastItemView` component.
/// It aligns the items to the leading edge and ensures they are spaced out with padding.
struct DailyForecastListView: View {
    /// An array of `DailyForecast` objects to be displayed in the list.
    let dailyForecasts: [DailyForecast]

    var body: some View {
        LazyVStack(alignment:.leading) {
            ForEach(dailyForecasts) { forecast in
                DailyForecastItemView(forecast: forecast)
                
                if forecast.id != dailyForecasts.last?.id {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DailyForecastListView(dailyForecasts: [DailyForecast.mock])
}
