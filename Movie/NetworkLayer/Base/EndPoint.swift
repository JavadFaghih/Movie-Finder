//
//  EndPoint.swift
//  Parental Control
//
//  Created by IOS on 27.02.2024.
//

import Foundation

public protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryParams: [URLQueryItem] { get }
    var additionalQueryParams: [URLQueryItem]? { get }
    var HTTPMethod: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: Encodable? { get }
}

extension EndPoint {
    var scheme: String {
        MovieApiInfo.scheme
    }
    var host: String {
        MovieApiInfo.host
    }
    var HTTPMethod: HTTPMethod {
        .GET
    }
    var body: Encodable? {
        nil
    }
    
    var queryParams: [URLQueryItem] {
        var items: [URLQueryItem] = additionalQueryParams ?? []
        items.append(.init(name: "api_key", value: MovieApiInfo.apiKey))
        return items
    }
    var header: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
