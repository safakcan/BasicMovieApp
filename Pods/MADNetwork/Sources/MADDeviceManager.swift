//
//  MADDeviceManager.swift
//  MADNetwork
//
//  Created by Erdi Tunçalp on 5.08.2021.
//  Copyright © 2021 Madduck. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif
#if canImport(AdSupport)
import AdSupport
#endif
#if canImport(CoreTelephony)
import CoreTelephony
#endif
#if canImport(AppKit)
import AppKit
#endif

class MADDeviceManager {

    init() {}

    func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    func getAppId() -> String? {
        return Bundle.main.bundleIdentifier
    }

    func getBundleId() -> String? {
        return Bundle.main.bundleIdentifier
    }

    func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    func getLanguage() -> String? {
        return Locale.current.languageCode
    }

    func getRegion() -> String? {
        if isSimulator() { return "US" }
        return Locale.current.regionCode?.uppercased()
    }

    func getIdfa() -> String? {
        #if canImport(AdSupport)
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        #else
        return nil
        #endif
    }

    func getIdfv() -> String? {
        #if os(iOS)
        return UIDevice.current.identifierForVendor?.uuidString
        #else
        return nil
        #endif
    }

    func getIpAddress() -> String? {
        return try? String(contentsOf: URL(string: "https://api.ipify.org")!)
    }

    func getSource() -> VoltranRegisterSource {
        return .none
    }

    func getBrand() -> String {
        #if os(iOS) || os(tvOS)
        return UIDevice.current.model
        #else
        return ""
        #endif
    }

    func getCarrierName() -> String? {
        #if os(iOS)
        if #available(iOS 12.0, *) {
            return CTTelephonyNetworkInfo().serviceSubscriberCellularProviders?.first?.value.carrierName
        } else {
            return nil
        }
        #else
        return nil
        #endif
    }

    func getDeviceId() -> String? {
        return getIdfv()
    }

    func getIosVersion() -> String {
        #if os(iOS)
        return UIDevice.current.systemVersion
        #elseif os(macOS)
        return String(NSAppKitVersion.current.rawValue)
        #else
        return ""
        #endif
    }

    func getModel() -> String {
        #if os(iOS) || os(watchOS) || os(tvOS)
        return Device.current.safeDescription
        #else
        return "macOS"
        #endif
    }

    func getScreenResolution() -> String? {
        #if os(iOS)
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return "\(Int(screenBounds.size.width * screenScale))*\(Int(screenBounds.size.height * screenScale))"
        #else
        return nil
        #endif
    }

    func getUserAgent() -> String {
        let brand = getBrand()
        let version = getIosVersion().replacingOccurrences(of: ".", with: "_")
        return "Mozilla/5.0 (\(brand); CPU \(brand) OS \(version) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile"
    }

}
