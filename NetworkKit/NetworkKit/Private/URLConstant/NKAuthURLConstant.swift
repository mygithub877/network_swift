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
    }
    struct SOCIAL {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_SOCIAL + path
        }
    }
    struct MP {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_OMP + path
        }
    }
    struct STOCK {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_STOCK + path
        }
    }
    struct API {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_API + path
        }
    }
    struct FILE {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_FILE + path
        }
    }
    struct STICKER {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_API + path
        }
    }
    struct ANALYTICS {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_TW_STOCK_INFO + path
        }
    }
    struct TWSTOCK {
        let URL: String
        init(path: String) {
            self.URL = _MOF_API_STOCK_TW + path
        }
    }
}
extension REST.USER{
    static let CAPTCHA_SEND = REST.USER(path: "/sms")
    static let LOGIN = REST.USER(path: "/login")
    static let LOGOUT = REST.USER(path: "/login/logout")
    static let THIRD_CHECK = REST.USER(path: "/login/third")
    static let THIRD_BIND = REST.USER(path: "/third")
    static let LOGIN_SWITCH = REST.USER(path: "/login/device")
    static let USER_TRANSFER = REST.USER(path: "/mobile")
    static let PHONE_CHECK = REST.USER(path: "/exist")
    static let AGROAL_TOKEN = REST.USER(path: "/agora/token")
    static let AGROAL_RTMTOKEN = REST.USER(path: "/agora/rtm/token")
    static func APP_VERSION(platform:Int,app:Int) -> REST.USER{
        return REST.USER(path: "/versions/new/\(platform)/\(app)")
    }
}
extension REST.SOCIAL{

}
extension REST.MP{

}
extension REST.STOCK{

}
extension REST.API{

}
extension REST.FILE{

}
extension REST.STICKER{

}
extension REST.ANALYTICS{

}
extension REST.TWSTOCK{

}
