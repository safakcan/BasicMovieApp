//
//  PopularMoviesModel.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import Foundation

struct MoviesPresentation {
//    var original_language : String?
    var title : String?
    var originalTitle : String?
    var overview : String?
    var posterPath : String?
    var releaseDate : String?
    var voteAverage : Float?
    
    init(movies: Movie) {
        title = movies.title
        originalTitle = movies.originalTitle
        overview = movies.overview
        posterPath = movies.posterPath
        releaseDate = movies.releaseDate
        voteAverage = movies.voteAverage
    }
}
