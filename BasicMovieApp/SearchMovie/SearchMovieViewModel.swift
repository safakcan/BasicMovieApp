//
//  SearchMovieViewModel.swift
//  BasicMovieApp
//
//  Created by Madduck on 18.10.2021.
//

import Foundation

struct SeatchMovieState {
    
    var searchMoviePresentations: [MoviesPresentation] = []
    fileprivate var searchMovieResponses: [Movie] = []
    
    mutating func updatePresentations() {
     searchMoviePresentations = searchMovieResponses.map{MoviesPresentation(movies: $0)}
    }
    
    enum Change {
        case loading
        case fetched
        case erroOccured(String?)
    }
}

class SearchMovieModel {
    
    var stateChangeHandler: ((SeatchMovieState.Change) -> Void)?
    private(set) var state = SeatchMovieState()
    
    init(state: SeatchMovieState) {
        self.state = state
    }
    
    private func emit(_ change: SeatchMovieState.Change) {
        stateChangeHandler?(change)
    }
    
    func fetchSearch(with name: String) {
        let request = SearchMovieRequest(query: name)
        self.emit(.loading)
        
        NetworkManager.shared.execute(request: request, completion: { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                self.state.searchMovieResponses = result.results ?? []
                self.state.updatePresentations()
                self.emit(.fetched)
            case .failure(let error):
                self.emit(.erroOccured(error.description ?? ""))
            }
        })
    }
}
