//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import SwiftUI
import ComposableArchitecture
import Utilities

/// WeatherDetailView: A view that displays detailed weather information including current, minutely, hourly, and daily forecasts.
///
/// This view takes a `Store` of `WeatherDetail` and displays the weather details along with options to load historical forecasts.
struct WeatherDetailView: View {
    /// The store containing the state and actions for the weather detail.
    let store: StoreOf<WeatherDetail>
    
    var body: some View {
        VStack {
            CurrentWeatherView(weatherDetail: store.weatherDetail)
            ScrollView {
                VStack(spacing: 16) {
                    ForecastListViewWithTitle(forecasts: store.weatherDetail.minutely, title: Constants.tenminutesorecats)
                    ForecastListViewWithTitle(forecasts: store.weatherDetail.hourly, title: Constants.hourlyforecasts)
                    DailyForecastView(dailyForecasts: store.weatherDetail.daily)
                    HistoricalForecastView(store: store)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(Constants.weatherdetails)
    }
}

#Preview {
    WeatherDetailView(store: Store(
        initialState: WeatherDetail.State(weatherDetail: .mock)) {
            WeatherDetail()
        })
}
