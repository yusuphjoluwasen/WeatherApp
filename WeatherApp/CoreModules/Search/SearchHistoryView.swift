//
//  SearchHistoryView.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import SwiftUI
import ComposableArchitecture
import Utilities

/// SearchHistoryView: A view that displays the search history and allows users to search for weather information.
///
/// This view uses a `Store` from the TCA framework to manage its state and actions. It displays a search bar,
/// the current search history, and a loading indicator when data is being fetched. When the view appears, it loads the search history
/// from the database. If the search query is changed, it debounces the change and fetches weather data after a delay.
///
/// - Properties:
///   - store: The store for managing the state and actions of the SearchList reducer.
struct SearchHistoryView: View {
    
    // MARK: - Properties
    
    /// The store for managing the state and actions of the SearchList reducer.
    @Bindable var store: StoreOf<SearchHistory>
    
    // MARK: - UI Rendering
    
    var body: some View {
        VStack {
            /// A search bar that binds to the search query in the store.
            SearchBar(text: $store.searchQuery.sending(\.searchQueryChanged))
            
            /// Display a loading indicator if the state is loading.
            if store.isLoading {
                LoadingView()
            }
            
            /// A list view that displays the search history.
            ScrollView(showsIndicators: false) {
                SearchListView(searchList: store.searches, onSelect: { search in
                    store.send(.searchItemTapped(search.city))
                })
            }
            
            Spacer()
        }
        .onAppear {
            /// Load search history from the database when the view appears.
            store.send(.loadSearchHistory)
        }
        .task(id: store.searchQuery) {
            /// Debounce the search query change and fetch weather data.
            do {
                try await Task.sleep(for: .milliseconds(1000))
                await store.send(.searchQueryChangeDebounced).finish()
            } catch {}
        }
        .navigationDestination(
            item: $store.scope(state: \.weatherDetail, action: \.weatherDetail)
        ) { store in
            WeatherDetailView(store: store)
        }
        ///Display error
        .alert(
            isPresented: .constant(store.error != nil),
            content: {
                Alert(
                    title: Text(Constants.error),
                    message: Text(store.error.toString),
                    dismissButton: .default(Text(Constants.close)) {
                        store.send(.dismissErrorAlert)
                    }
                )
            }
        )
    }
}

#Preview {
    SearchHistoryView(store: Store(
        initialState: SearchHistory.State(
            searches: [Search.mock],
            isLoading: false
        )
    ) {
        SearchHistory()
    })
}

#Preview("Loading State") {
    SearchHistoryView(store: Store(
        initialState: SearchHistory.State(
            searches: [],
            isLoading: true
        )
    ) {
        SearchHistory()
    })
}
