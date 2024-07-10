//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation
enum DateFormat: String {
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
    case hourMinute = "h:mm a"
    case hour = "h a"
    case fullDateWithTime = "EEE MMM dd yyyy h a"
    case dayOfWeekShort = "E"
}

extension String {
    func toDate(format: DateFormat = DateFormat.iso8601) -> Date? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format.rawValue
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
         return dateFormatter.date(from: self)
     }

    func formatDate(from inputFormat: DateFormat = DateFormat.iso8601, to outputFormat: DateFormat) -> String? {
         guard let date = self.toDate(format: inputFormat) else {
             print("Failed to parse date string")
             return nil
         }
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = outputFormat.rawValue
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
     }
    
    var toCelcius : String{
        return "\(self)\u{00B0}C"
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.iso8601.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: self)
    }
}

