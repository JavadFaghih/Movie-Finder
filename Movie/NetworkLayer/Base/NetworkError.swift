//
//  NetworkError.swift
//  Parental Control
//
//  Created by IOS on 27.02.2024.
//

import Foundation


public enum NetworkError: String, Sendable, Error, LocalizedError, Codable, Equatable {
    case invalidURL
    case decode
    case unexpectedStatusCode
    case connectLost
    case timeout
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalid URL"
        case .decode:
            return "decoding error"
        case .unknown:
            return "an unknown error happened"
        case .unexpectedStatusCode:
            return "unexpected status code"
        case .connectLost:
            return "connection lost"
        case .timeout:
            return "time out"
        }
    }
}
