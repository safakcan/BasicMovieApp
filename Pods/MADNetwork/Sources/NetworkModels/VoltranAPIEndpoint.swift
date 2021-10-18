//
//  VoltranAPIEndpoint.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public protocol VoltranAPIEndpoint: Endpoint {}

public extension VoltranAPIEndpoint {

    var api: API {
        return apiForEnvironment(Global.environment)
    }

    var defaultHeaders: [String: String] {
        var customHeaders: [String: String] = [:]
        if let token = NetworkManager.shared.voltranAccessToken {
            customHeaders["Authorization"] = "Bearer \(token)"
        }
        customHeaders["Content-Type"] = contentType.rawValue
        return HeaderBuilder(with: self).build(customHeaders: customHeaders)
    }

    func apiForEnvironment(_ environment: Environment) -> API {
        switch environment {
        default:
            return API(baseURL: BaseURL(scheme: "https", host: environment.voltranBaseURL))
        }
    }

}
