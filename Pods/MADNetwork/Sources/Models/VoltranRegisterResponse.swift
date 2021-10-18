//
//  VoltranRegisterResponse.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct VoltranRegisterResponse: Decodable {

    public var accessToken: String
    public var currentSubscription: [MADSubscriptionStatus]
    public var forceUpdate: Bool
    public var softUpdate: Bool

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case currentSubscription = "current_subscription"
        case forceUpdate = "force_update"
        case softUpdate = "soft_update"
    }

}
