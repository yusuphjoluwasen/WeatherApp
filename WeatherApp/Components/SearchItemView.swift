//
//  SearchItemView.swift
//  WeatherApp
//
//  Created by Guru King on 08/07/2024.
//

import SwiftUI
import Utilities

/// A view that displays a search item with city name, current temperature, and forecast details.
///
/// The view takes a `Search` object which contains the weather details for a specific location.
/// It displays the city's name, current temperature, and a brief description of the weather along
/// with an icon. Below that, it shows a list of forecasts for different times.
///
/// This view is designed to be used in a list of search results or as a detailed view for a
/// specific search.
///
struct SearchItemView: View {
    /// The search object containing weather details.
    let search: Search
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchHeaderView(search: search)
            SearchDescriptionView(search: search)
            Divider()
                .background(Color.white)
                .padding(.vertical, 5)
            
            ForecastListViewWithTitle(forecasts: search.forecasts, title: Constants.hourlyforecasts)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        .padding([.horizontal, .top])
       
    }
}

#Preview {
    SearchItemView(search: Search.mock)
}
