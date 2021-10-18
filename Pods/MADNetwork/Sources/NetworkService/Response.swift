//
//  Response.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

import Foundation

/// Holds all response related information
public struct Response<Value> {

    /// The request object that this response belongs to
    public let request: URLRequest?

    /// HTTP response data for the request
    public let response: HTTPURLResponse?

    /// Raw response data for the request
    public let data: Data?

    /// Parsed response value for the given type
    public let result: Result<Value, NetworkingError>

}
