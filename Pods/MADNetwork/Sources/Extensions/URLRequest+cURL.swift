//
//  URLRequest+cURL.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 7.05.2021.
//

import Foundation

extension URLRequest {

    /**
     Returns a cURL command representation of this URL request.
     */
    var curlString: String {
        guard let url = self.url,
              let method = self.httpMethod else { return "$ curl command could not be created" }

        var components = ["$ curl --location"]

        components.append("--request \(method)")

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                components.append("--header '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            components.append("--data-raw '\(body)'")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n\t")
    }

}
