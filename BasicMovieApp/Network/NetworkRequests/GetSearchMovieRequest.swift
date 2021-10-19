//
//  GetSearchMovieRequest.swift
//  BasicMovieApp
//
//  Created by Madduck on 17.10.2021.
//

import Foundation
import MADNetwork

struct SearchMovieRequest: TradeAPIEndpoint {

    typealias Response = PopularMovieResponse
    
    var method: HTTPMethod = .get
    var path: String = "/3/search/movie"
    var parameters: [String : Any]? = [:]
    
    init(query: String) {
        self.parameters = [
            "api_key": NetworkUtils.apiKey,
            "query": query
        ]
    }
}
