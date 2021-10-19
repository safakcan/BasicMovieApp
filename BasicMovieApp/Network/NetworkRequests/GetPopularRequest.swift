//
//  GetPopularRequest.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import Foundation
import MADNetwork

struct PopularMovieRequest: TradeAPIEndpoint {

    typealias Response = PopularMovieResponse

    var method: HTTPMethod = .get
    var path: String = "/3/movie/popular"
    var parameters: [String : Any]? = [:]
    
    init(page: Int) {
        self.parameters = [
            "api_key": NetworkUtils.apiKey,
            "page": page
        ]
    }
}

struct PopularMovieResponse : Codable {
    var totalPages: Int?
    var results : [Movie]?
}

struct Movie: Codable {
    var title : String?
    var originalTitle : String?
    var overview : String
    var posterPath : String?
    var releaseDate : String?
    var voteAverage : Float?
    
        enum CodingKeys: String, CodingKey {
            case releaseDate = "release_date"
            case posterPath = "poster_path"
            case originalTitle = "original_title"
            case voteAverage = "vote_average"
            case overview,title
        }
}
