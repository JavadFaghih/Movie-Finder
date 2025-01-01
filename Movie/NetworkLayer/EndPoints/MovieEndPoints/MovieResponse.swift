//
//  MovieResponse.swift
//  Movie
//
//  Created by Javad Faghih on 1/1/25.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}

extension MovieResponse {
    struct Movie: Codable {
        let id: Int?
        let title: String?
        let originalTitle: String?
        let overview: String?
        let posterPath: String?
        let backdropPath: String?
        let genreIDs: [Int]?
        let releaseDate: String?
        let popularity: Double?
        let voteAverage: Double?
        let voteCount: Int?
        let adult: Bool?
        let originalLanguage: String?
    }
}
extension MovieResponse.Movie {
    func toDisplayMovieModel() -> DisplayMovieModel {
        .init(
            title: originalTitle ?? "-",
            overview: overview ?? "-",
            languages: originalLanguage ?? "-",
            posterURL: .init(string: "https://image.tmdb.org/t/p/w300\(posterPath ?? "")")!
        )
    }
}
