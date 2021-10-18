//
//  VoltranReceiptValidationRequest.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct VoltranReceiptValidationRequest: VoltranAPIEndpoint {

    public typealias Response = VoltranBaseResponse<[MADSubscriptionStatus]>

    public var path: String = "/api/v1/itunes/receipt"
    public var method: HTTPMethod = .post
    public var parameters: [String : Any]?

    public init(receipt: String, sandbox: Bool) {
        parameters = [
            "receipt": receipt,
            "sandbox": sandbox
        ]
    }

}
