//
//  Endpoint.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

import Foundation

public enum ContentType: String {
    case xWwwFormEncoded = "application/x-www-form-urlencoded"
    case applicationJson = "application/json"
}

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?)
}

/// Holds all the information to build a request
public protocol Endpoint: URLRequestConvertible {

    /// A response type should be defined with every `Endpoint` implementation
    /// This type will be used to parse the response into concrete types
    associatedtype Response: Decodable

    /// The API definition this endpoint belongs to
    var api: API { get }

    /// Path component for this endpoint
    var path: String { get }

    /// HTTP method this endpoint uses
    var method: HTTPMethod { get }

    /// Parameters will be parsed based on the HTTP method
    /// For `GET` it will be URL encoding and for `POST` it will be HTTP body JSON encoding
    var parameters: [String: Any]? { get set }

    /// Default header values to be included in every request for this environment
    var defaultHeaders: [String: String] { get }

    /// Any additional header values that should be added along with default header
    /// values defined in `API`
    /// Users can override default header values of API using the same keys
    var additionalHeaders: [String: String] { get }

    var encoding: ParameterEncoding { get }
    var contentType: ContentType { get }
    var task: HTTPTask { get }

}

// MARK: - Default values

public extension Endpoint {

    /// Returns an empty dictionary for default header values
    var defaultHeaders: [String: String] { return [:] }

    /// Returns an empty dictionary for additional header values
    var additionalHeaders: [String: String] { return [:] }

    /// Returns default http encodings
    var encoding: ParameterEncoding {
        switch method {
        case .get, .head:
            return .urlEncoding
        default:
            return .jsonEncoding
        }
    }

    /// Returns JSON as a default contentType
    var contentType: ContentType { return .applicationJson }

    /// Returns parameter encoding as a default
    var task: HTTPTask { return .requestParameters(bodyParameters: parameters) }

}

// MARK: - URLRequestConvertible

extension Endpoint {

    /// Construct `URLRequest`
    public func asURLRequest() throws -> URLRequest {
        // Construct the URL
        var components = URLComponents()
        components.scheme = api.baseURL.scheme
        components.host = api.baseURL.host
        components.path = path

        // This will throw an error if provided information is not correct
        guard let url = components.url else {
            throw NetworkingError.parameterEncodingFailed(reason: .missingURL)
        }

        // Create the request and assign appropriate values
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = defaultHeaders.merging(additionalHeaders, uniquingKeysWith: { $1 })

        // Try to encode request and return it
        switch task {
        case .request: break
        case .requestParameters(let parameters):
            try encoding
                .encode(urlRequest: &request,
                        parameters: parameters)
        }

        return request
    }

}
