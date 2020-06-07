//
//  NKBaseSession.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/5/31.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import Alamofire

class NKBaseSession: NSObject {
    typealias NKSessionCompletion = (NSDictionary?,NKError?)->()
    func GET(url:String,parameters:[String:Encodable]?=nil,headers:[String:Encodable]?=nil,completion:NKSessionCompletion?) {
        let aheaders: HTTPHeaders = [
            .authorization(username: "Username", password: "Password"),
            .userAgent(userAgent())
        ]
        
       let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: aheaders, interceptor: nil, requestModifier: nil)
        request.response { (data) in
            DLog("\(data.debugDescription)")
        }
    }
    
    
    
    
    private func userAgent() -> String {
        let version = String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"])
        let systemVersion = UIDevice.current.systemVersion
        let scale = String(format: "%.2f", UIScreen.main.scale)
        let str = "MOF/\(version)__iOS/\(systemVersion)__\(nk_deviceTypeDetail)__Scale/\(scale)"
        return str
    }
}
