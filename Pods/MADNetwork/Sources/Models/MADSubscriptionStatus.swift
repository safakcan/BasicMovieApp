//
//  MADSubscriptionStatus.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct MADSubscriptionStatus: Codable {

    public var purchasedProductId: String?
    public var transactionId: String?
    public var originalTransactionId: String?
    public var expiresDate: String?
    public var isInIntroOfferPeriod: String?
    public var isTrialPeriod: String?
    public var originalPurchaseDate: String?
    public var subscriptionStatus: Bool?

    // Fax specific parameters
    public var sendFaxStatus: Bool?
    public var receiveFaxStatus: Bool?

    enum CodingKeys: String, CodingKey {
        case purchasedProductId = "active_subscription"
        case transactionId = "original_transaction_id"
        case originalTransactionId = "transaction_id"
        case expiresDate = "expires_date"
        case isInIntroOfferPeriod = "is_in_intro_offer_period"
        case isTrialPeriod = "is_trial_period"
        case originalPurchaseDate = "original_purchase_date"
        case subscriptionStatus = "subscription_status"

        case sendFaxStatus = "send_fax_status"
        case receiveFaxStatus = "receive_fax_status"
    }

    public var getExpireDate: Date? {
        guard let date = expiresDate else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        return formatter.date(from: date)
    }

    public var getPurchaseDate: Date? {
        guard let date = originalPurchaseDate else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        return formatter.date(from: date)
    }

    public var isExpired: Bool {
        return subscriptionStatus ?? true
    }
}
