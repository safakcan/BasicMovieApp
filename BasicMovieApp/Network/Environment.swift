//
//  Environment.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import Foundation
import MADNetwork

typealias NetworkManager = MADNetwork.NetworkManager
typealias BaseResponse = MADNetwork.VoltranBaseResponse

extension Environment {
    var defaultBaseURL: String {
        return "api.themoviedb.org"
    }
}
