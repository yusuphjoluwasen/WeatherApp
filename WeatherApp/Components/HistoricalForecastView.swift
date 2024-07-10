//
//  HistoricalForecastView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI
import ComposableArchitecture

/// HistoricalForecastView: A view for displaying historical forecast information and loading historical data.
///
/// This view takes a `Store` of `WeatherDetail` and displays options to load historical forecasts along with the loaded historical forecasts.
struct HistoricalForecastView: View {
    /// The store containing the state and actions for the weather detail.
    let store: StoreOf<WeatherDetail>
    
    var body: some View {
        VStack{
            if store.dailyHistory.isEmpty {
                LoadHistoricalForecastButtonView(store: store)
            } else if store.isLoadingHistorical {
                LoadingView()
            }
            
            if !store.hourlyHistory.isEmpty {
                ForecastListViewWithTitle(forecasts: store.hourlyHistory, title: Constants.hourlyforecasts)
            }
            
            if !store.dailyHistory.isEmpty {
                DailyForecastView(dailyForecasts: store.dailyHistory)
            }
        }
    }
}

#Preview {
    HistoricalForecastView(store: Store(
        initialState: WeatherDetail.State(weatherDetail: .mock, dailyHistory: [DailyForecast.mock, DailyForecast.mock])) {
            WeatherDetail()
        })
}
