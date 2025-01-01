//
//  MoviesListViewModel.swift
//  Movie
//
//  Created by Javad Faghih on 1/1/25.
//

import Combine
import Foundation

class MoviesListViewModel: ObservableObject {
    
    private let network: Networkable
    private var cancellables: Set<AnyCancellable> = []
    @Published var movies: [DisplayMovieModel]
    @Published var searchedMovie: String
    
    init(
        network: Networkable,
        movies: [DisplayMovieModel],
        searchedMovie: String
    ) {
        self.network = network
        self.movies = movies
        self.searchedMovie = searchedMovie
        self.listenToSearch()
    }
    
    convenience init() {
        self.init(
            network: NetworkService.instance,
            movies: [],
            searchedMovie: ""
        )
    }
    

    private func fetchMovies(by name: String) async {
        do {
            let movies: MovieResponse = try await network.sendRequest(endPoint: MovieEndPoints.fetchMovies(name: name))
            await MainActor.run {
                self.movies = movies.results.map {$0.toDisplayMovieModel() }
            }
        } catch {
            print("Error Happened on Fetching Movies:\(error.localizedDescription)")
        }
    }
    
    func searchMovies(by name: String) {
        Task {
            await fetchMovies(by: searchedMovie)
        }
    }
    
    func listenToSearch() {
        $searchedMovie
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] name in
            guard let self else { return }
                self.searchMovies(by: name)
        }.store(in: &cancellables)
    }
}
