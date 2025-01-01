//
//  MovieRow.swift
//  Movie
//
//  Created by Javad Faghih on 1/1/25.
//

import SwiftUI

struct MovieRow: View {
    let movie: DisplayMovieModel
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 75, height: 75)
                Text(movie.title)
                    .font(.footnote)
                    .scaledToFit()
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: 75, alignment: .leading)
            }
            VStack(alignment: .leading) {
                Text(movie.overview)
                    .font(.caption)
                Text(movie.languages)
                    .font(.caption2)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        })
        .frame(maxHeight: 120)
    }
}

#Preview {
    MovieRow(movie: .example)
}
