//
//  SearchHeaderView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// A view that displays the header information for a search item.
///
/// This view takes a `Search` object and displays the city's name, current temperature,
/// and the time of the forecast.
///
/// Example usage:
/// ```swift
/// SearchHeaderView(search: Search.mock)
/// ```
struct SearchHeaderView: View {
    /// The search object containing weather details.
    let search: Search
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(search.time)
                .font(.system(.caption2))
            
            HStack {
                Text(search.city)
                    .font(.system(.title2, weight: .bold))
                
                Spacer()
                
                Text(search.temperature)
                    .font(.system(.title2, weight: .bold))
            }
        }
    }
}

#Preview {
    SearchHeaderView(search: Search.mock)
}
