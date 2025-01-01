//
//  Networkable.swift
//  Parental Control
//
//  Created by IOS on 27.02.2024.
//

import Combine
import Foundation

protocol Networkable {
    var encoder: JSONEncoder { get set }
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
    func sendRequest<T: Decodable>(endPoint: EndPoint) async throws -> T
}

extension Networkable {
    func createRequest(endPoint: EndPoint) throws -> URLRequest {
        guard let url = makeURL(from: endPoint) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        request.httpMethod = endPoint.HTTPMethod.rawValue
      
        for (field, value) in endPoint.header ?? [:] {
            request.allHTTPHeaderFields?.updateValue(value, forKey: field)
        }
        if let body = endPoint.body {
            let encoded = try encoder.encode(body)
            request.httpBody = encoded
        }
        return request
    }
    
    private func makeURL(from endPoint: EndPoint) -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = endPoint.scheme
        urlComponent.host = endPoint.host
        urlComponent.path = endPoint.path
        urlComponent.queryItems = endPoint.queryParams
        return urlComponent.url
    }
}
