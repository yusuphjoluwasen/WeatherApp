//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation
extension Date {
    func formatDate(to outputFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
}
