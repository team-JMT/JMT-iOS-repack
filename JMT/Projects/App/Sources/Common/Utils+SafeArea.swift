//
//  Utils+SafeArea.swift
//  JMTeng
//
//  Created by PKW on 2024/01/17.
//

import Foundation
import UIKit

extension Utils {
    public static let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
    /**
     # safeAreaTopInset
     - Note: 현재 디바이스의 safeAreaTopInset값 반환
     */
    static func safeAreaTopInset() -> CGFloat {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }.first
            let topPadding = keyWindow?.safeAreaInsets.top
            return topPadding ?? Utils.STATUS_HEIGHT
        } else if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            return topPadding ?? Utils.STATUS_HEIGHT
        } else {
            return Utils.STATUS_HEIGHT
        }
    }
    
    /**
     # safeAreaBottomInset
     - Note: 현재 디바이스의 safeAreaBottomInset값 반환
     */
    static func safeAreaBottomInset() -> CGFloat {
        // iOS 13 이상인 경우
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }.first
            let bottomPadding = keyWindow?.safeAreaInsets.bottom
            return bottomPadding ?? 0.0
        }
        // iOS 11 이상, iOS 13 미만인 경우
        else if #available(iOS 11.0, *) {
            let keyWindow = UIApplication.shared.keyWindow
            let bottomPadding = keyWindow?.safeAreaInsets.bottom
            return bottomPadding ?? 0.0
        }
        // iOS 11 미만인 경우
        else {
            return 0.0
        }
    }
}

