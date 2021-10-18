//
//  BasicMovieViewModel.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import UIKit
import MADNetwork

struct BasicMovieState {
    
    fileprivate var movieResponses: [Movie] = []
    var moviePresentations: [MoviesPresentation] = []
    
    enum Change {
        case loading
        case fetched
        case erroOccured(String?)
    }
    
    mutating func updatePresentations(with dataType: DataType) {
        switch dataType {
        case .popularData:
            moviePresentations.append(contentsOf: movieResponses.map{MoviesPresentation(movies: $0)})
        case .searchData:
            moviePresentations = movieResponses.map{MoviesPresentation(movies: $0)}
        }
    }
    
    enum DataType {
        case popularData
        case searchData
    }
}

class BasicMovieViewModel {
    
    var stateChangedHandler : ((BasicMovieState.Change) -> Void)?
    var stateDataChangedHandler : ((BasicMovieState.DataType) -> Void)?
    private(set) var state = BasicMovieState()
    
    init(state: BasicMovieState){
        self.state = state
    }
    
    private func emit(_ change: BasicMovieState.Change) {
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
                self.state.updatePresentations(with: .popularData)
                self.emit(.fetched)
            case .failure(let error):
                self.emit(.erroOccured(error.description ?? ""))
            }
        })
    }
    
    func fetchSearch(with name: String) {
        let request = SearchMovieRequest(query: name)
        self.emit(.loading)
        
        NetworkManager.shared.execute(request: request, completion: { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                self.state.movieResponses = result.results ?? []
                self.state.updatePresentations(with: .searchData)
                self.emit(.fetched)
            case .failure(let error):
                self.emit(.erroOccured(error.description ?? ""))
            }
        })
    }
    
}
