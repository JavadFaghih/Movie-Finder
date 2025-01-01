//
//  ContentView.swift
//  Movie
//
//  Created by Javad Faghih on 1/1/25.
//

import SwiftUI

struct MovieList: View {
    @StateObject var viewModel: MoviesListViewModel = .init()
    var body: some View {
        NavigationView {
            List(viewModel.movies, id: \.id) { movie in
                    MovieRow(movie: movie)
                    .listRowSeparator(.hidden)
                }
            .navigationTitle("Movies")
            .listStyle(.plain)
            }
        .searchable(text: $viewModel.searchedMovie, placement: .toolbar, prompt: "Find Movies")
    }
}

#Preview {
    NavigationView {
        MovieList()
    }
}
