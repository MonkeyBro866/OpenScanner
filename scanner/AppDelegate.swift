//
//  AppDelegate.swift
//  scanner
//
//  Created by smh on 2025/10/11.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UMCommonSwift.setLogEnabled(bFlag: true)
        UMCommonSwift.initWithAppkey(appKey: "68e78aa7644c9e2c204a2a99", channel: "App Store")
        // 启动广告SDK
        UMCommonSwift.start()
        AdUnionManager.shared.loadSplashAd(adUnitID: "100003615")
        
        return true
    }
}
