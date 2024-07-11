//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Guru King on 06/07/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct WeatherApp: App {
    /// The global store for managing the state and actions of the search history feature.
       ///
       /// This store is created with an initial state of `SearchHistory.State` and uses the `SearchHistory` reducer
       /// to handle actions and mutate the state accordingly. The store is passed down to the root view of the navigation stack `SearchHistoryView`
       /// to provide access to the state and actions for displaying and managing the search history.
    static let store = Store(initialState: SearchHistory.State()) {
        SearchHistory()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SearchHistoryView(store: WeatherApp.store)
            }
        }
    }
}
