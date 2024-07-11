//
//  SearchBar.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import SwiftUI

/// SearchBar: A custom search bar component with a text field and search icon.
///
/// This component creates a search bar with a magnifying glass icon on the left and a text field
/// for input. It can be used to allow users to input search queries in your app.
///
/// - Parameters:
///   - text: The text to display and bind with the search bar.
///   - placeholder: The placeholder text for the search bar.
struct SearchBar: View {
    /// The text to display and bind with the search bar.
    @Binding var text: String
    
    /// The placeholder text for the search bar.
    var placeholder: String = "Search"
    
    // MARK: - UI Rendering

    var body: some View {
        HStack {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 10)

            // Text field for search input
            TextField(placeholder, text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(.alphabet)
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}

#Preview("Search Bar With Placeholder") {
    SearchBar(text: .constant(""), placeholder: "Enter query")
}
