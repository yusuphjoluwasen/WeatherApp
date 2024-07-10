//
//  LoadHistoricalForecastButtonView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI
import ComposableArchitecture
import Utilities

/// LoadHistoricalForecastButtonView: A view that displays a button to load historical forecasts.
///
/// This view takes a `ViewStore` of `WeatherDetail` and displays a button to fetch historical forecasts.
struct LoadHistoricalForecastButtonView: View {
    /// The view store containing the state and actions for the weather detail.
    let store: StoreOf<WeatherDetail>
    
    var body: some View {
        Button(Constants.loadhistoricalforecasts) {
            store.send(.fetchHistoricalForecasts)
        }
    }
}

#Preview {
    LoadHistoricalForecastButtonView(store: Store(
        initialState: WeatherDetail.State(weatherDetail: .mock)) {
            WeatherDetail()
        })
}
