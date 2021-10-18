//
//  Data+PrettyPrint.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 8.05.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

extension Data {
    
    var prettyPrint: String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(decoding: jsonData, as: UTF8.self)
        } else {
            return String(decoding: self, as: UTF8.self)
        }
    }
    
}
