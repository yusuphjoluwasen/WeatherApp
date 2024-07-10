//
//  NetworkingExtension.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import Foundation

public protocol EndPointType{
    var baseurl:String {get}
    var path:String {get}
    var params:[String:String]? { get }
    var method:HTTPMethod { get }
}

public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum NetworkServiceError: Error, Equatable {
    case invalidURL
    case decodingError(String)
    case genericError(String)
    case invalidResponseCode(Int)
}

extension NetworkServiceError:LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL encountered. Can't proceed with the request", comment: "")
        case .decodingError(let message):
            return NSLocalizedString("Encountered an error while decoding incoming server response. \(message)", comment: "")
        case .genericError(let message):
            return message
        case .invalidResponseCode(let responseCode):
            return NSLocalizedString("Invalid response code encountered from the server. Expected 200, received \(responseCode)", comment: "")
        }
    }
}

extension Data {
    var prettyString: NSString? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) ?? nil
    }
}


