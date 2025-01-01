//
//  MovieTests.swift
//  MovieTests
//
//  Created by Javad Faghih on 1/1/25.
//

import XCTest
@testable import Movie

final class EndPointSuccessTests: XCTestCase {
    
    func testFetchMoviesEndpointProperties() throws {
        // Arrange
        let movieName = "Inception"
        let endpoint = MovieEndPoints.fetchMovies(name: movieName)
        
        // Act & Assert
        
        // Test scheme
        XCTAssertEqual(endpoint.scheme, MovieApiInfo.scheme, "The scheme should match the value in MovieApiInfo.")
        
        // Test host
        XCTAssertEqual(endpoint.host, MovieApiInfo.host, "The host should match the value in MovieApiInfo.")
        
        // Test path
        XCTAssertEqual(endpoint.path, "/3/search/movie", "The path should be '/3/search/movie' for fetchMovies.")
        
        // Test HTTP Method
        XCTAssertEqual(endpoint.HTTPMethod, .GET, "The HTTP method for fetchMovies should be GET.")
        
        // Test header
        XCTAssertEqual(endpoint.header?["Content-Type"], "application/json", "The Content-Type header should be 'application/json'.")
        
        // Test query parameters
        let queryParams = endpoint.queryParams
        XCTAssertTrue(queryParams.contains(where: { $0.name == "api_key" && $0.value == MovieApiInfo.apiKey }), "Query parameters should include the API key.")
        XCTAssertTrue(queryParams.contains(where: { $0.name == "query" && $0.value == movieName }), "Query parameters should include the movie name as 'query'.")
        
        // Test additional query parameters
        let additionalQueryParams = endpoint.additionalQueryParams
        XCTAssertNotNil(additionalQueryParams, "Additional query parameters should not be nil.")
        XCTAssertEqual(additionalQueryParams?.first?.name, "query", "The name of the additional query parameter should be 'query'.")
        XCTAssertEqual(additionalQueryParams?.first?.value, movieName, "The value of the additional query parameter should match the provided movie name.")
        
        // Test body
        XCTAssertNil(endpoint.body, "The body for GET requests should be nil.")
    }
}

