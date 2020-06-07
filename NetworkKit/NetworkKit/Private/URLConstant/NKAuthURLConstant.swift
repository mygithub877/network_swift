//
//  NKAuthURLConstant.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/6/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import Foundation

class REST {
    struct USER {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_USER + path
        }
        
        static let CAPTCHA_SEND = USER(path: "/sms")
        static let LOGIN = USER(path: "/login")
        static let LOGOUT = USER(path: "/login/logout")
        static let THIRD_CHECK = USER(path: "/login/third")
        static let THIRD_BIND = USER(path: "/third")
        static let LOGIN_SWITCH = USER(path: "/login/device")
        static let USER_TRANSFER = USER(path: "/mobile")
        static let PHONE_CHECK = USER(path: "/exist")
        static let AGROAL_TOKEN = USER(path: "/agora/token")
        
        static let AGROAL_RTMTOKEN = USER(path: "/agora/rtm/token")
        
        static func APP_VERSION(platform:Int,app:Int) -> USER{
            return USER(path: "/versions/new/\(platform)/\(app)")
        }
    }
    
}

//let MOF_URL_CAPTCHA_SEND = _MOF_API_USER + "/sms"
//
//let MOF_URL_LOGIN = _MOF_API_USER + "/login"
//
//let MOF_URL_LOGOUT = _MOF_API_USER + "/login/logout"
//
//let MOF_URL_THIRD_CHECK = _MOF_API_USER + "/login/third"
//
//let MOF_URL_THIRD_BIND = _MOF_API_USER + "/third"
//
//let MOF_URL_LOGIN_SWITCH = _MOF_API_USER + "/login/device"
//
//let MOF_URL_USER_TRANSFER = _MOF_API_USER + "/mobile"
//
//let MOF_URL_PHONE_CHECK = _MOF_API_USER + "/exist"
//
//let MOF_URL_APP_VERSION = _MOF_API_USER + "/versions/new"
//
//let MOF_URL_AGROAL_TOKEN = _MOF_API_USER + "/agora/token"
//
//let MOF_URL_AGROAL_RTMTOKEN = _MOF_API_USER + "/agora/rtm/token"
