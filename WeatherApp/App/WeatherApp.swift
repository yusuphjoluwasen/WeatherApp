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
    static let store = Store(initialState: SearchList.State()) {
        SearchList()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SearchHistoryView(store: WeatherApp.store)
            }
        }
    }
}
