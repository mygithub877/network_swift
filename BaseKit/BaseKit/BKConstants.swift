//
//  BKConstants.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

public let SCREEN_WIDTH = UIScreen.main.bounds.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.height
public let STATUS_BAR_HEIGHT = UIApplication.shared.statusBarFrame.height
public let NAV_BAR_HEIGHT = UIApplication.shared.statusBarFrame.height + 44
public let SAFE_HEIGHT_BOTTOM = isIPhoneXX() ? 34.0 : 0
public let iPhone4 = CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhone5 = CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhone6 = CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhone6P = CGSize(width: 1242, height: 2208).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhoneX = CGSize(width: 1125, height: 2436).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhoneXS = CGSize(width: 1125, height: 2436).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhoneXR = CGSize(width: 828, height: 1792).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhoneXS_MAX = CGSize(width: 1242, height: 2688).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
public let iPhoneX_X = isIPhoneXX()
private func isIPhoneXX() -> Bool{
    if #available(iOS 11.0, *) {
        let height = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        if  height > 0 {
            return true
        }
    }
    return false
}
