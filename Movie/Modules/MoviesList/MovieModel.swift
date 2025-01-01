//
//  MovieModel.swift
//  Movie
//
//  Created by Javad Faghih on 1/1/25.
//

import Foundation

struct DisplayMovieModel: Decodable {
    let title: String
    let overview: String
    let languages: String
    let posterURL: URL
}

extension DisplayMovieModel: Identifiable {
    var id: String { UUID().uuidString }
}

extension DisplayMovieModel {
    static var example: DisplayMovieModel {
        .init(
            title: "Example Title",
            overview: "Example Overview",
            languages: "Example Languages",
            posterURL: URL(string: "https://image.tmdb.org/t/p/w300/2YGejZlPnvMHbtZfMyfwaelVOeF.jpg")!
        )
    }
}
