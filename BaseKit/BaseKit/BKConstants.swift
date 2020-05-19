//
//  BKConstants.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//
public struct SCREEN {
    public static let WIDTH = UIScreen.main.bounds.width
    public static let HEIGHT = UIScreen.main.bounds.height
    public static let SAFE_BOTTOM = isIPhoneXX() ? 34.0 : 0
    public static let SAFE_TOP = isIPhoneXX() ? UIApplication.shared.statusBarFrame.height : 0
    public static let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    public static let NAV_BAR = UIApplication.shared.statusBarFrame.height + 44
    init() {
    }
}
public struct iPhone {
    /// 4s
    public static let is4 = CGSize(width: 640, height: 960).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
    /// 5 5s se 5c
    public static let is5 = CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
    /// 6 7 8
    public static let is678 = CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
    
    /// 6p 7p 8p
    public static let is678P = CGSize(width: 1242, height: 2208).equalTo(UIScreen.main.currentMode?.size ?? CGSize.zero)
    
    /// 刘海屏系列
    public static let isX_X = isIPhoneXX()
    init() {
    }
}
private func isIPhoneXX() -> Bool{
    if #available(iOS 11.0, *) {
        let height = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        if  height > 0 {
            return true
        }
    }
    return false
}
