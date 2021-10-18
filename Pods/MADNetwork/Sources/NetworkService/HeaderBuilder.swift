//
//  HeaderBuilder.swift
//  MADNetwork
//
//  Created by Bilal Arslan on 13.04.2021.
//

#if os(iOS)
import UIKit
#endif

public class HeaderBuilder<T: Endpoint> {

    private var endpoint: T

    public init(with endpoint: T) {
        self.endpoint = endpoint
    }

    public func build(customHeaders: [String: String]? = nil) -> [String: String] {
        var headers = [String: String]()
        headers["Timestamp"] = String(Date().timeIntervalSince1970 * 1000)

        if let customHeaders = customHeaders {
            headers = headers.merging(customHeaders, uniquingKeysWith: { $1 })
        }

        return headers
    }

}
