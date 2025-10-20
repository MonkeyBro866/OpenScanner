//
//  AdUnionManager.swift
//  scanner
//
//  Created by smh on 2025/10/18.
//

import Foundation
import UIKit

// 定义 Swift 协议，便于 SwiftUI 调用
@objc public protocol AdUnionManagerDelegate: AnyObject {
    /// 请求广告数据成功回调
    func splashDidLoad(_ splashAd: UMUnionSplashAd)
    /// 请求广告数据失败回调
    /// @param error 失败信息
    func splashDidFail(_ splashAd: UMUnionSplashAd?, error: Error)
    /// 广告显示回调
    func splashDidExpose(_ splashAd: UMUnionSplashAd)
    /// 广告点击回调
    func splashDidClick(_ splashAd: UMUnionSplashAd)
    /// 广告关闭回调
    func splashDidClose(_ splashAd: UMUnionSplashAd)
    /// 广告剩余时间(s)
    func splashTimeRemaining(_ time: UInt)
    /// 视频广告播放状态回调
    func splashMediaPlayerStatus(_ splashAd: UMUnionSplashAd, status: UMUnionMediaPlayerStatus)
    /// 广告详情页即将打开
    func splashDetailWillPresent(_ splashAd: UMUnionSplashAd)
    /// 广告详情页关闭
    func splashDetailDidClose(_ splashAd: UMUnionSplashAd)
}

public class AdUnionManager: NSObject {
    public static let shared = AdUnionManager()

    public weak var delegate: AdUnionManagerDelegate?

    private var splashAd: UMUnionSplashAd?

    private override init() {
        super.init()
    }

    /// 初始化并加载广告（传入广告位 ID 和展示用 UIViewController）
    public func loadSplashAd(adUnitID: String) {
        // 初始化广告位
        self.splashAd = UMUnionSplashAd(slotId: adUnitID)
        self.splashAd?.delegate = self
        self.splashAd?.timeout = 2
        // 广告请求
        self.splashAd?.load()
    }
}

// 获取当前可用的 UIWindow
private func currentKeyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
}

// MARK: — 实现 OC 协议回调
extension AdUnionManager: UMUnionSplashAdDelegate {
    /// 请求广告数据成功回调
    public func uadSplashDidLoad(_ splashAd: UMUnionSplashAd) {
        // 展示全屏广告
        DispatchQueue.main.async {
            if let window = currentKeyWindow() {
                self.splashAd?.showFullScreenAd(in: window, skip: nil)
            }
        }
        delegate?.splashDidLoad(splashAd)
    }

    /// 请求广告数据失败回调
    /// @param error 失败信息
    public func uadSplashDidLoad(_ splashAd: UMUnionSplashAd, failWithError error: (any Error)?) {
        let err = error ?? NSError(domain: "SplashAd", code: -1, userInfo: nil)
        delegate?.splashDidFail(splashAd, error: err)
    }

    /// 广告显示回调
    public func uadSplashExposeSuccess(_ splashAd: UMUnionSplashAd) {
        delegate?.splashDidExpose(splashAd)
    }

    /// 广告点击回调
    public func uadSplashClicked(_ splashAd: UMUnionSplashAd) {
        delegate?.splashDidClick(splashAd)
    }

    /// 广告关闭回调
    public func uadSplashClose(_ splashAd: UMUnionSplashAd) {
        delegate?.splashDidClose(splashAd)
    }

    /// 广告剩余时间(s)
    public func uadSplashTime(_ time: UInt) {
        delegate?.splashTimeRemaining(time)
    }

    /// 视频广告播放状态回调
    public func uadSplash(_ splashAd: UMUnionSplashAd, mediaPlayerStatus status: UMUnionMediaPlayerStatus) {
        delegate?.splashMediaPlayerStatus(splashAd, status: status)
    }

    /// 广告详情页即将打开
    public func uadSplashDetailViewWillPresent(_ splashAd: UMUnionSplashAd) {
        delegate?.splashDetailWillPresent(splashAd)
    }

    /// 广告详情页关闭
    public func uadSplashViewDetailViewClosed(_ splashAd: UMUnionSplashAd) {
        delegate?.splashDetailDidClose(splashAd)
    }
}
