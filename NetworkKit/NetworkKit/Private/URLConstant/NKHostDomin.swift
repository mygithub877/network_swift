//
//  NKHostDomin.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/6/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import Foundation

#if DEV_DEBUG
let MOF_HTTP_SCHEME = "https"
let MOF_REST_HOST = "dev-restful.moftech.net"
let MOF_CDN_HOST = "dev-cdn.moftechnology.net"
let MOF_STOCK_HOST = "dev-stock.moftech.net"
let LOG_API_OPEN = true
#elseif BETA
let MOF_HTTP_SCHEME = "https"
let MOF_REST_HOST = "beta-restful.moftech.net"
let MOF_CDN_HOST = "beta-cdn.moftechnology.net"
let MOF_STOCK_HOST = "stock.finmaster.com"
let LOG_API_OPEN = false
#elseif PROD_DEBUG
let MOF_HTTP_SCHEME = "https"
let MOF_REST_HOST = "restful.moftech.net"
let MOF_CDN_HOST = "cdn.finmastercdn.com"
let MOF_STOCK_HOST = "stock.finmaster.com"
let LOG_API_OPEN = true
#else
let MOF_HTTP_SCHEME = "https"
let MOF_REST_HOST = "restful.moftech.net"
let MOF_CDN_HOST = "cdn.finmastercdn.com"
let MOF_STOCK_HOST = "stock.finmaster.com"
let LOG_API_OPEN = false
#endif

let MOF_REST_DOMIN = "\(MOF_HTTP_SCHEME)://\(MOF_REST_HOST)"
let MOF_CDN_DOMIN = "\(MOF_HTTP_SCHEME)://\(MOF_CDN_HOST)"
let MOF_STOCK_DOMIN = "\(MOF_HTTP_SCHEME)://\(MOF_STOCK_HOST)"


public func DLog(_ item: Any, file : String = #file, lineNum : Int = #line) {
    if LOG_API_OPEN {
         let fileName = (file as NSString).lastPathComponent
         print("#FILE:\(fileName)[LINE:\(lineNum)]")
         print(item)
    }
}
