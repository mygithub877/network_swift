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
    typealias NKSessionCompletion = ()->()
    func GET(url:String,parameters:[String:Encodable]?=nil,headers:[String:Encodable]?=nil,completion:NKSessionCompletion?=nil) {
        let aheaders: HTTPHeaders = [
            .authorization(username: "Username", password: "Password"),
            .userAgent("")
        ]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: aheaders, interceptor: nil, requestModifier: nil).response { (data) in
            
        }
    }
    
}
