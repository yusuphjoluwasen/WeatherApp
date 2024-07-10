//
//  RequestFactory.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import Foundation

/// Factory class responsible for generating URLRequest objects based on the endpoint and payload.
final class RequestFactory {

    /// Creates a URLRequest based on the provided endpoint.
    /// - Parameter endpoint: The endpoint type specifying the base URL, path, and HTTP method.
    /// - Returns: The generated URLRequest.
    static func request(endpoint: EndPointType) -> URLRequest? {
        return configureRequest(with: endpoint)
    }
    
    /// Configures a URLRequest based on the provided endpoint.
    /// - Parameter endpoint: The endpoint type specifying the base URL, path, param and HTTP method.
    /// - Returns: The configured URLRequest.
    private static func configureRequest(with endpoint: EndPointType) -> URLRequest? {
        let urlString = endpoint.baseurl + endpoint.path
        var components = URLComponents(string: urlString)
        
        if var params = endpoint.params?.map({ URLQueryItem(name: $0.key, value: $0.value) }) {
            if let token = fetchToken() {
                params.append(URLQueryItem(name: "apikey", value: token))
            }
            components?.queryItems = params
        }
        
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = endpoint.method.rawValue
        return request
    }
    
    /// Fetches token from environment variables.
    /// - Returns: The fetched token or nil if not available.
    static func fetchToken() -> String? {
        return ProcessInfo.processInfo.environment["TOKEN"]
    }
}
