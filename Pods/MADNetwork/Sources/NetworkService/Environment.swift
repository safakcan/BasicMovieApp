//
//  Environment.swift
//  MADNetwork
//
//  Created by Egemen Ayhan on 6.05.2021.
//

import Foundation

public enum EnvironmentType: String {
    case debug = "Debug"
    case beta = "Beta"
    case prod = "Release"
}

public struct Environment {
    public var type: EnvironmentType

    public init(type: EnvironmentType) {
        self.type = type
    }
}

public extension Environment {

    var voltranBaseURL: String {
        switch self.type {
        case .debug, .beta:
            return "test-voltran.madduck.app"
        case .prod:
            return "voltran.madduck.app"
        }
    }

}

public struct Global {

    public static var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            return Environment(type: EnvironmentType(rawValue: configuration) ?? .prod)
        }
        return Environment(type: .prod)
    }()

}
