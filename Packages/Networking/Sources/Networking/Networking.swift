//
//  Networking.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//

import Foundation

public protocol NetworkProtocol{
    func call<response:Codable>(request:EndPointType) async throws -> response
}

// Network class that conforms to the NetworkProtocol
public final class Network:NetworkProtocol{
    
    // MARK: - Properties
    
    private let urlSession: URLSession
    
    // MARK: - Initializers
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    
    public func call<response:Codable>(request:EndPointType) async throws -> response{
        
        guard let urlRequest = RequestFactory.request(endpoint: request) else {
            throw NetworkServiceError.invalidURL
        }
        
        let (data, res) = try await urlSession.data(for: urlRequest)
        
        guard let res = res as? HTTPURLResponse,
              res.statusCode == 200 else {
            
            throw NetworkServiceError.genericError("Something went wrong")
        }

        do {
            let output = try JSONDecoder().decode(response.self, from: data)
            return output
        } catch {
            // Handle decoding errors by throwing a custom error with the error description.
            throw NetworkServiceError.decodingError(error.localizedDescription)
        }
    }
}

