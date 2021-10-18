//
//  VoltranRegisterRequest.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

import Foundation

public struct VoltranRegisterRequest: VoltranAPIEndpoint {

    public typealias Response = VoltranBaseResponse<VoltranRegisterResponse>

    public var path: String = "/api/v2/register"
    public var method: HTTPMethod = .post
    public var parameters: [String : Any]?

    public init(userID: String, fcmToken: String?) {
        self.parameters = Params(userID: userID, fcmToken: fcmToken).asParameter
    }

    struct Params: Encodable {
        var appID: String?
        var appVersion: String?
        var region: String?
        var language: String?
        var idfa: String?
        var idfv: String?
        var userID: String
        var fcmToken: String
        var ipAddress: String
        var device: MADDeviceInfo
        var source: VoltranRegisterSource

        enum CodingKeys: String, CodingKey {
            case appID = "appId"
            case appVersion, region, language, idfa, idfv
            case userID = "userId"
            case fcmToken, ipAddress, device, source
        }

        init(userID: String, fcmToken: String?) {
            let deviceManager = MADDeviceManager()
            self.appID = deviceManager.getAppId()
            self.appVersion = deviceManager.getAppVersion()
            self.region = deviceManager.getRegion()
            self.language = deviceManager.getLanguage()
            self.idfa = deviceManager.getIdfa()
            self.idfv = deviceManager.getIdfv()
            self.userID = userID
            self.fcmToken = fcmToken ?? ""
            self.ipAddress = deviceManager.getIpAddress() ?? ""
            self.device = MADDeviceInfo()
            self.source = deviceManager.getSource()
        }

    }

}
