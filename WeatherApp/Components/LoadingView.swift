//
//  LoadingView.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import SwiftUI

/// LoadingView: A view that displays a loading indicator.
///
/// This view shows a `ProgressView` indicating that data is being loaded.
struct LoadingView: View {
    var body: some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }
}

#Preview {
    LoadingView()
}
