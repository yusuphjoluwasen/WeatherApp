//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation
import SwiftUI
import Utilities

/// DailyForecastView: A  view for displaying daily forecast information.
///
/// This view takes an array of `DailyForecast` objects and displays them in a vertically scrollable list.
struct DailyForecastView: View {
    /// An array of daily forecast objects containing daily weather details.
    let dailyForecasts: [DailyForecast]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Constants.dailyforecasts)
                .font(.headline)
            
            DailyForecastListView(dailyForecasts: dailyForecasts)
        }
        .padding(.top)
    }
}

#Preview {
    DailyForecastView(dailyForecasts: [DailyForecast.mock, DailyForecast.mock])
}
