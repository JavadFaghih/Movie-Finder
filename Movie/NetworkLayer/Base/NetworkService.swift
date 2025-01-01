//
//  NetworkService.swift
//  Parental Control
//
//  Created by IOS on 27.02.2024.
//

import Combine
import Foundation

final class NetworkService: Networkable {
    
    static var instance = NetworkService()
    
    var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: configuration,
                          delegate: nil, delegateQueue: .current)
    }()
    
    private init() {}
    
    func sendRequest<T>(endPoint: EndPoint) async throws -> T where T : Decodable {
        let urlRequest = try createRequest(endPoint: endPoint)
        return try await request(from: urlRequest)
    }
    
    private func request<T>(from urlRequest: URLRequest) async throws -> T where T : Decodable  {
        return try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: urlRequest) { [unowned self] data, response, error in
                guard error == nil else {
                    switch (error! as NSError).code {
                    case NSURLErrorNetworkConnectionLost:
                        continuation.resume(throwing: NetworkError.connectLost)
                    case NSURLErrorTimedOut:
                        continuation.resume(throwing: NetworkError.timeout)
                    default:
                        continuation.resume(throwing: NetworkError.unknown)
                    }
                    return
                }
                guard response is HTTPURLResponse else {
                    continuation.resume(throwing: NetworkError.invalidURL)
                    return
                }
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    do {
                        debugPrint("response before decoding \(String(decoding: data!, as: UTF8.self))")
                        let responseBody = try self.decoder.decode(T.self, from: data ?? Data())
                        continuation.resume(returning: responseBody)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        debugPrint("Failed to decode \(T.self) missing key '\(key.stringValue)' not found – \(context.debugDescription)")
                        continuation.resume(throwing: NetworkError.decode)
                    } catch DecodingError.typeMismatch(_, let context) {
                        debugPrint("Failed to decode \(T.self)type mismatch – \(context.debugDescription)")
                        continuation.resume(throwing: NetworkError.decode)
                    } catch DecodingError.valueNotFound(let type, let context) {
                        debugPrint("Failed to decode \(T.self) missing \(type) value – \(context.debugDescription)")
                        continuation.resume(throwing: NetworkError.decode)
                    } catch DecodingError.dataCorrupted(_) {
                        debugPrint("Failed to decode \(T.self) it appears to be invalid JSON")
                        continuation.resume(throwing: NetworkError.decode)
                    } catch {
                        debugPrint("Failed to decode \(T.self) \(error.localizedDescription)")
                        continuation.resume(throwing: NetworkError.decode)
                    }
                } else {
                    do {
                        debugPrint("response error before decoding \(String(decoding: data!, as: UTF8.self))")
                        let error = try self.decoder.decode(NetworkError.self, from: data!)
                        continuation.resume(throwing: error)
                    } catch {
                        debugPrint("Failed to decode \(T.self) \(error.localizedDescription)")
                        continuation.resume(throwing: NetworkError.unknown)
                    }
                }
            }
            task.resume()
        }
    }
}
