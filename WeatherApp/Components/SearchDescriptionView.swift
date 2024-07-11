//
//  SearchDescriptionView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// A view that displays the weather description and icon for a search item.
///
/// This view takes a `Search` object and displays a brief description of the weather along
/// with an icon representing the weather condition.
///
struct SearchDescriptionView: View {
    /// The search object containing weather details.
    let search: Search
    
    // MARK: - UI Rendering
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(search.weatherDescription)
                    .font(.system(.caption2))
                
                Text("Feels like \(search.temperatureApparent)")
                    .font(.system(.caption2))
            }
            
            Spacer()
            
            Image(search.weatherIconName)
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}

#Preview {
    SearchDescriptionView(search: Search.mock)
}
