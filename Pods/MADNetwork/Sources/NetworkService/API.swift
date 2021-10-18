//
//  API.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

/// Represents an environment to connect to
public struct API {

    /// Root URL to the environment
    public var baseURL: BaseURL

    /// Init
    public init(baseURL: BaseURL) {
        self.baseURL = baseURL
    }

}
