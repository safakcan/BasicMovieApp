//
//  BasicMovieViewModel.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import UIKit
import MADNetwork

struct PopularMovieState {
    
    fileprivate var movieResponses: [Movie] = []
    var moviePresentations: [MoviesPresentation] = []
    
    enum Change {
        case loading
        case fetched
        case erroOccured(String?)
    }
    
    mutating func updatePresentations() {
        moviePresentations.append(contentsOf: movieResponses.map{MoviesPresentation(movies: $0)})
    }
}

class PopularMovieViewModel {
    
    var stateChangedHandler : ((PopularMovieState.Change) -> Void)?
    private(set) var state = PopularMovieState()
    
    init(state: PopularMovieState){
        self.state = state
    }
    
    private func emit(_ change: PopularMovieState.Change) {
        stateChangedHandler?(change)
    }
    
     func reinstallMoviePresentation() {
         self.state.moviePresentations.removeAll()
         self.fetchPopular(with: 1)
    }
    
    func fetchPopular(with page: Int) {
        let request = PopularMovieRequest(page: page)
        self.emit(.loading)
        NetworkManager.shared.execute(request: request, completion: { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                self.state.movieResponses = result.results ?? []
                self.state.updatePresentations()
                self.emit(.fetched)
            case .failure(let error):
                self.emit(.erroOccured(error.description ?? ""))
            }
        })
    }
    
}
