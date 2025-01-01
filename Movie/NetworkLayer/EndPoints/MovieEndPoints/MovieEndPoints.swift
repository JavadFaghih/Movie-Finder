//
//  AlertEndPoints.swift
//  Parental Control
//
//  Created by IOS on 7.08.2024.
//

import Foundation

enum MovieEndPoints: EndPoint {
    case fetchMovies(name: String)
    
    var path: String {
        switch self {
        case .fetchMovies:
            return "/3/search/movie"
        }
    }
    
    var method: HTTPMethod {
    switch self {
        case .fetchMovies:
        return .GET
        }
    }
    
    var additionalQueryParams: [URLQueryItem]? {
        switch self {
        case .fetchMovies(name: let name):
            return [URLQueryItem(name: "query", value: name)]
        }
    }
}
