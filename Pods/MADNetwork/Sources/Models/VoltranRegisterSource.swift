//
//  VoltranRegisterSource.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public enum VoltranRegisterSource: String, Codable {
    case facebook = "Facebook"
    case adjust = "Adjust"
    case none = "None"
}
