//
//  TradeEndpoint.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import Foundation
import MADNetwork

protocol TradeAPIEndpoint: Endpoint {}

extension TradeAPIEndpoint {

    var api: API {
        return API(baseURL: BaseURL(scheme: "https", host: Environment(type: .prod).defaultBaseURL))
    }

}
