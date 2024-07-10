//
//  SearchListView.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import SwiftUI
import Utilities

/// SearchListView: A view that holds and displays a list of search items.
///
/// This view takes an array of `Search` objects and displays each one using the `SearchItemView` component.
/// It animates any changes to the list using a default animation.
/// If the `searchList` is empty, it shows a `ContentUnavailableView` with a message indicating that there are no searches available.
///
struct SearchListView: View {
    /// An array of `Search` objects to be displayed in the list.
    let searchList: [Search]
    
    /// A closure that gets called when a search item is selected.
    let onSelect: (Search) -> Void
    
    // MARK: - UI Rendering
    
    var body: some View {
        VStack {
            if searchList.isEmpty {
                /// Displays a message and an icon when there are no search items.
                ContentUnavailableView(
                    Constants.nosearches,
                    systemImage: "magnifyingglass"
                )
            } else {
                /// Displays the list of search items using `SearchItemView` for each item.
                ForEach(searchList) { search in
                    SearchItemView(search: search)
                        .onTapGesture {
                            onSelect(search)
                        }
                }
                /// Animates changes to the list of search items.
                .animation(.default, value: searchList)
            }
        }
    }
}

#Preview {
    SearchListView(searchList: [Search.mock, Search.mock], onSelect: { search in})
}

#Preview("Search List Empty State") {
    SearchListView(searchList: [], onSelect: { search in})
}
