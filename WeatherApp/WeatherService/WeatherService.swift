//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Guru King on 09/07/2024.
//


import ComposableArchitecture
import Networking

@DependencyClient
struct WeatherClient {
    var forecast: (_ location:String) async throws -> WeatherResponse
    var history: (_ location:String) async throws -> WeatherResponse
}

extension WeatherClient: TestDependencyKey {
  static let previewValue = Self(
    forecast: { _ in .mock },
    history: { _ in .mock }
  )
    
  static let testValue = Self()
}

extension DependencyValues {
  var weatherClient: WeatherClient {
    get { self[WeatherClient.self] }
    set { self[WeatherClient.self] = newValue }
  }
}

// MARK: - Live API implementation
extension WeatherClient: DependencyKey {
  static let liveValue = Self(
    forecast: { result in
        let req = WeatherApi.forecast(param: ["location":result])
        let network:NetworkProtocol = Network()
        return try await network.call(request: req)
    },
    history: { location in
               let req = WeatherApi.history(param: ["location": location])
               let network: NetworkProtocol = Network()
               return try await network.call(request: req)
           }
    )
}
