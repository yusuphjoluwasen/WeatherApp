//
//  MinutelyForecastView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation
import SwiftUI

/// ForecastListViewWithTitle: A  view for displaying minutely forecast information.
///
/// This view takes an array of `Forecast` objects and displays them in a horizontally scrollable list.
struct ForecastListViewWithTitle: View {
    
    /// An array of forecast objects.
    let forecasts: [Forecast]
    
    /// A title for the forecast which must be specified
    var title:String
    
    // MARK: - UI Rendering
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                ForecastListView(forecasts: forecasts)
            }
            .padding(.top)
        }
    }
}

#Preview {
    ForecastListViewWithTitle(forecasts: [Forecast.mock, Forecast.mock], title: "Hourly Forecast")
}
