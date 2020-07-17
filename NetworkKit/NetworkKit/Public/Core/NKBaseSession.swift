//
//  NKBaseSession.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/5/31.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import Alamofire

public class NKBaseSession: NSObject {
    public typealias NKSessionCompletion = (NKResponse)->()
    public func request(url:String,method: HTTPMethod = .get,parameters:[String:Encodable]?=nil,headers:[String:Encodable]?=nil,completion:NKSessionCompletion?) {
        let aheaders: HTTPHeaders = [
            .authorization(username: "Username", password: "Password"),
            .userAgent(userAgent())
        ]
        
       let request = AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: aheaders, interceptor: nil, requestModifier: nil)
        request.responseJSON { (data) in
            DLog(data.value ?? "")
            if data.value != nil {
                let response = NKResponse.deserialize(from: data.value as? NSDictionary)
                response?.data=data;
                response?.statusCode = data.response?.statusCode;
                response?.method = data.request?.method?.rawValue;
                response?.header = (data.response?.allHeaderFields ?? [:]) as NSDictionary;
                response?.URL = data.request?.url
                if response != nil {
                    if response?.code == 0 {
                        response?.isSuccess=true
                    }else{
                        let desc=String(describing: response?.response)
                        response?.error = .server(code: response?.code, err: desc)
                    }
                }else{
                    response?.error = .other(err: "解析失敗，無效的數據", detailErr: nil)
                }
                if completion != nil {
                    completion!(response!);
                }
            }else{
                let response = NKResponse()
                response.data=data;
                let statusCode = data.response?.statusCode
                response.statusCode=statusCode;
                response.method = data.request?.method?.rawValue;
                response.header = (data.response?.allHeaderFields ?? [:]) as NSDictionary;
                response.URL = data.request?.url
                if data.response != nil &&  statusCode != 200 {
                    response.error = .http(statusCode: statusCode!)
                }else{
                    response.error = NKError(err: data.error)
                }
                if completion != nil {
                    completion!(response);
                }
            }
        }
    }
    public func GET(url:String,parameters:[String:Encodable]?=nil,headers:[String:Encodable]?=nil,completion:NKSessionCompletion?) {
        request(url: url,method: .get,parameters: parameters, headers: headers, completion: completion)
    }
    
    
    
    
    private func userAgent() -> String {
        let version = String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"])
        let systemVersion = UIDevice.current.systemVersion
        let scale = String(format: "%.2f", UIScreen.main.scale)
        let str = "MOF/\(version)__iOS/\(systemVersion)__\(nk_deviceTypeDetail)__Scale/\(scale)"
        return str
    }
}
