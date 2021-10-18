//
//  MADDeviceInfo.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct MADDeviceInfo: Codable {

    public var brand: String?
    public var carrier: String?
    public var deviceID: String?
    public var iOSVersion: String?
    public var model: String?
    public var screenRes: String?
    public var userAgent: String?

    enum CodingKeys: String, CodingKey {
        case brand, carrier
        case deviceID = "deviceId"
        case iOSVersion, model, screenRes, userAgent
    }

    public init() {
        let deviceManager = MADDeviceManager()
        self.brand = deviceManager.getBrand()
        self.carrier = deviceManager.getCarrierName()
        self.deviceID = deviceManager.getDeviceId()
        self.iOSVersion = deviceManager.getIosVersion()
        self.model = deviceManager.getModel()
        self.screenRes = deviceManager.getScreenResolution()
        self.userAgent = deviceManager.getUserAgent()
    }

}
