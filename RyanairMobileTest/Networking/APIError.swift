//
//  APIError.swift
//  RyanairMobileTest
//
//  Created by Marcus Presa Käld
//

import SwiftUI

enum APIError: Error, LocalizedError {
    case invalidURL
    case badStatus(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badStatus(let code):
            return "Unexpected HTTP status code: \(code)"
        case .decoding(let err):
            return "Decoding failed: \(err.localizedDescription)"
        }
    }
}
