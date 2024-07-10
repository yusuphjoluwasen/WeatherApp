//
//  File.swift
//  
//
//  Created by Guru King on 10/07/2024.
//

import Foundation
import Networking

public class MockNetwork: NetworkProtocol {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    public init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
    
    public func call<response: Codable>(request: EndPointType) async throws -> response {
        if let error = error {
            throw error
        }
        
        guard let data = data, let urlResponse = urlResponse else {
            throw NetworkServiceError.genericError("No data or response")
        }
        
        guard let httpResponse = urlResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkServiceError.genericError("Something went wrong")
        }
        
        do {
            let output = try JSONDecoder().decode(response.self, from: data)
            return output
        } catch {
            throw NetworkServiceError.decodingError(error.localizedDescription)
        }
    }
}
