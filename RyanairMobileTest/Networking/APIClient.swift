//
//  APIClient.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

protocol APIClientProtocol {
    func fetchStations() async throws -> [Station]
    func fetchItineraries(params: FlightSearchParams) async throws -> Itineraries
}

final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            return URLSession(configuration: config)
        }(),
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            return decoder
        }()
    ) {
        self.session = session
        self.decoder = decoder
    }


    func fetchStations() async throws -> [Station] {
        let url = APIEndpoints.stations.url
        var request = URLRequest(url: url)
        request.httpMethod = APIEndpoints.stations.getMethod
        request.allHTTPHeaderFields = APIEndpoints.stations.headers

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.badStatus(-1)
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus(http.statusCode)
        }
        do {
            let wrapper = try decoder.decode(StationResponse.self, from: data)
            return wrapper.stations
        } catch {
            throw APIError.decoding(error)
        }
    }
    
    func fetchItineraries(params: FlightSearchParams) async throws -> Itineraries {
        let endpoint = APIEndpoints.itineraries(params)
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.getMethod
        request.allHTTPHeaderFields = endpoint.headers
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.badStatus(-1)
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus(http.statusCode)
        }
        do {
            let wrapper = try decoder.decode(Itineraries.self, from: data)
            return wrapper
        } catch {
            throw APIError.decoding(error)
        }
    }
    
}
