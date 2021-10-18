//
//  HTTPError.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

import Foundation

public enum HTTPError: Error {
    case badRequest(data: Data?)
    case unauthorized(data: Data?)
    case forbidden(data: Data?)
    case notFound(data: Data?)
    case preconditionFailed(data: Data?)
    case preconditionRequired(data: Data?)
    case tooManyRequest(data: Data?)
    case internalError(data: Data?)

    case noData(data: Data?)
    case undefined(data: Data?)
}

extension HTTPError: LocalizedError {

    init?(statusCode: Int, data: Data?) {
        switch statusCode {
        case 400: self = .badRequest(data: data)
        case 401: self = .unauthorized(data: data)
        case 403: self = .forbidden(data: data)
        case 404: self = .notFound(data: data)
        case 412: self = .preconditionFailed(data: data)
        case 428: self = .preconditionRequired(data: data)
        case 429: self = .tooManyRequest(data: data)
        case 500: self = .internalError(data: data)
        default: return nil
        }
    }

    public var rawValue: String? {
        switch self {
        case .badRequest(_): return "badRequest"
        case .unauthorized(_): return "unauthorized"
        case .forbidden(_): return "forbidden"
        case .notFound(_): return "notFound"
        case .preconditionFailed(_): return "preconditionFailed"
        case .preconditionRequired(_): return "preconditionRequired"
        case .tooManyRequest(_): return "tooManyRequest"
        case .internalError(_): return "internalError"
        case .noData(_): return "noData"
        case .undefined(_): return "undefined"
        }
    }

    public var code: Int? {
        switch self {
        case .badRequest(_): return 400
        case .unauthorized(_): return 401
        case .forbidden(_): return 403
        case .notFound(_): return 404
        case .preconditionFailed(_): return 412
        case .preconditionRequired(_): return 428
        case .tooManyRequest(_): return 429
        case .internalError(_): return 500
        default: return nil
        }
    }

    public var data: Data? {
        switch self {
        case .badRequest(let data),
             .unauthorized(let data),
             .notFound(let data),
             .preconditionFailed(let data),
             .preconditionRequired(let data),
             .internalError(let data),
             .forbidden(let data),
             .tooManyRequest(let data),
             .noData(data: let data),
             .undefined(let data):
            return data
        }
    }

    public var response: String? {
        if let data = data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    public var message: String {
        return data?.format()?.message ?? localizedDescription
    }

}

private extension Data {
    func format() -> ErrorBody? {
        return try? JSONDecoder().decode(ErrorBody.self, from: self)
    }
}

public struct ErrorBody: Codable {

    public var success: Bool?
    public var message: String?

}
