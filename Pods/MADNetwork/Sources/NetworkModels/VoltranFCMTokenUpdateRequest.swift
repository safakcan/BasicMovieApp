//
//  VoltranFCMTokenUpdateRequest.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct VoltranFCMTokenUpdateRequest: VoltranAPIEndpoint {

    public typealias Response = VoltranBaseResponse<Int>

    public var path: String = "/api/v1/fcm"
    public var method: HTTPMethod = .post
    public var parameters: [String : Any]?

    public init(token: String) {
        parameters = [
            "token": token
        ]
    }

}
