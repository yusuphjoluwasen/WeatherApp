//
//  Optionals.swift
//  WeatherApp
//
//  Created by Guru King on 10/07/2024.
//

import Foundation

extension Optional {
    public func or(other: Wrapped) -> Wrapped {
        if let ret = self {
            return ret
        } else {
            return other
        }
    }
}

extension Optional where Wrapped == String {
    var toString:String {
        return self.or(other: "")
    }
}

extension Optional where Wrapped == Int {
    var toInt:Int {
        return self.or(other: 0)
    }
}
