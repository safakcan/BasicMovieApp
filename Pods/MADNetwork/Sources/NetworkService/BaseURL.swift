//
//  BaseURL.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

/// Represents a URL for an environment
public struct BaseURL {

    /// Schema of the URL (https)
    public var scheme: String

    /// Hostname of the URL (www.example.com)
    public var host: String

    public init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }

}
