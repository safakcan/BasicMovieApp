//
//  VoltranBaseResponse.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct VoltranBaseResponse<T: Decodable>: Decodable {
    public var success: Bool
    public var message: String?
    public var result: T
}
