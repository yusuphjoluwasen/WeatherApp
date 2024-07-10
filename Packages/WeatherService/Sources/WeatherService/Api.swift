//
//  Api.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//


import Networking

public enum ApiConstants{
    static let baseurl = "https://api.tomorrow.io/v4/weather/"
    static let forecast = "forecast"
    static let history = "history/recent"
}

public enum WeatherApi{
    case forecast(param:[String:String])
    case history(param:[String:String])
}

extension WeatherApi:EndPointType{
    public var path: String {
        switch self {
        case .forecast:
            return ApiConstants.forecast
        case .history:
            return ApiConstants.history
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .forecast:
            return HTTPMethod.get
        case .history:
            return HTTPMethod.get
        }
    }
    
    public var baseurl: String {
        return ApiConstants.baseurl
    }
    
    public var params: [String : String]? {
        switch self {
        case .forecast(param: let param):
            return param
        case .history(param: let param):
            return param
        }
    }
}
