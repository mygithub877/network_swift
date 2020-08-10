//
//  NKBaseSession.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/5/31.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import Alamofire
var UpdatingAESKeyTask:URLSessionDataTask?

public class NKBaseSession: NSObject {
    public typealias NKSessionCompletion = (NKResponse)->()
    
    @discardableResult
    public func request(url:String,method: HTTPMethod ,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,encoding:ParameterEncoding = URLEncoding.default,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        var aheaders: HTTPHeaders = [
            .authorization(username: "Username", password: "Password"),
            .userAgent(userAgent())
        ]
        headers?.forEach({ (k,v) in
            aheaders.add(name: k, value: v)
        })
       let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: aheaders)
        request.responseJSON { (data) in
            let value = (data.value as? NSDictionary) ?? NSDictionary()
            DLog("\(data.request?.httpMethod ?? "") \(data.request?.url?.description ?? "") \n参数:\(String(describing: parameters))\n******RESPONSE\n\(value)\n******RESPONSE")
            
            if data.value != nil {
                let response = NKResponse.deserialize(from: data.value as? NSDictionary)
                response?.data=data;
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
        return (request.task as? URLSessionDataTask)
    }
    func checkAESKeyEnabled(response:HTTPURLResponse?) -> Bool{
        let headerCode=response?.allHeaderFields["X-Secret-Code"] as? Int
        if headerCode == 9999 {
            if UpdatingAESKeyTask == nil {
                DLog("\n*************秘钥过期****************\n")
                DLog(response?.allHeaderFields ?? "")
                NKEncryptHandler.default.updateAESKey()
            }
            return false
        }
        return true
    }
    @discardableResult
    public func GET(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        return request(url: url,method: .get,parameters: parameters, headers: headers, completion: completion)
    }
    @discardableResult
    public func DELETE(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        return request(url: url,method: .delete,parameters: parameters, headers: headers, completion: completion)
    }
    @discardableResult
    public func POST(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        return request(url: url,method: .post,parameters: parameters, headers: headers, completion: completion)
    }
    @discardableResult
    public func POST_SEC(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        var task:URLSessionDataTask?
        task = request(url: url, method: .post, parameters: parameters, headers: headers,encoding: EncryptURLEncoding.default){ (response) in
            if task == UpdatingAESKeyTask {
                UpdatingAESKeyTask=nil
            }
            if self.checkAESKeyEnabled(response: response.data?.response) == false {
                let task = self.POST_SEC(url: url, completion: completion)
                if UpdatingAESKeyTask != nil {
                    UpdatingAESKeyTask = task
                }
            }else{
                if completion != nil {
                    completion!(response)
                }
            }
        }
        return task
    }
    @discardableResult
    public func PUT(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        return request(url: url,method: .put,parameters: parameters, headers: headers, completion: completion)
    }
    @discardableResult
    public func PUT_SEC(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        var task:URLSessionDataTask?
        task = request(url: url, method: .put, parameters: parameters, headers: headers, encoding: EncryptURLEncoding.default){ (response) in
            if task == UpdatingAESKeyTask {
                UpdatingAESKeyTask=nil
            }
            if self.checkAESKeyEnabled(response: response.data?.response) == false {
                let task = self.PUT_SEC(url: url, completion: completion)
                if UpdatingAESKeyTask != nil {
                    UpdatingAESKeyTask = task
                }
            }else{
                if completion != nil {
                    completion!(response)
                }
            }
        }
        return task
    }
    @discardableResult
    public func POST_JSON(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        return request(url: url,method: .post,parameters: parameters, headers: headers,encoding: JSONEncoding.default, completion: completion)
    }
    @discardableResult
    public func POST_JSON_SEC(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        var task:URLSessionDataTask?
        task = request(url: url, method: .post, parameters: parameters, headers: headers,encoding: EncryptJSONEncoding.default){ (response) in
            if task == UpdatingAESKeyTask {
                UpdatingAESKeyTask=nil
            }
            if self.checkAESKeyEnabled(response: response.data?.response) == false {
                let task = self.POST_JSON_SEC(url: url, completion: completion)
                if UpdatingAESKeyTask != nil {
                    UpdatingAESKeyTask = task
                }
            }else{
                if completion != nil {
                    completion!(response)
                }
            }
        }
        return task
    }
    @discardableResult
    public func PUT_JSON(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        return request(url: url,method: .put,parameters: parameters, headers: headers,encoding: JSONEncoding.default, completion: completion)
    }
    @discardableResult
    public func PUT_JSON_SEC(url:String,parameters:[String:Encodable]?=nil,headers:[String:String]?=nil,completion:NKSessionCompletion?) -> URLSessionDataTask? {
        var task:URLSessionDataTask?
        task = request(url: url, method: .put, parameters: parameters, headers: headers,encoding: EncryptJSONEncoding.default){ (response) in
            if task == UpdatingAESKeyTask {
                UpdatingAESKeyTask=nil
            }
            if self.checkAESKeyEnabled(response: response.data?.response) == false {
                let task = self.PUT_JSON_SEC(url: url, completion: completion)
                if UpdatingAESKeyTask != nil {
                    UpdatingAESKeyTask = task
                }
            }else{
                if completion != nil {
                    completion!(response)
                }
            }
        }
        return task
    }
    private func userAgent() -> String {
        let version = String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"])
        let systemVersion = UIDevice.current.systemVersion
        let scale = String(format: "%.2f", UIScreen.main.scale)
        let str = "MOF/\(version)__iOS/\(systemVersion)__\(nk_deviceTypeDetail)__Scale/\(scale)"
        return str
    }
}

public struct EncryptURLEncoding: ParameterEncoding {

    // MARK: Properties

    /// Returns a default `URLEncoding` instance with a `.methodDependent` destination.
    public static var `default`: EncryptURLEncoding { EncryptURLEncoding() }

    // MARK: Encoding

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters);
        urlRequest.httpBody = NKAESProvider.default().aes_decrypt(urlRequest.httpBody)
//            NKEncryptHandler.default.encrypt(httpBody: urlRequest.httpBody)
        return urlRequest
    }
}

// MARK: -

/// Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
/// request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
public struct EncryptJSONEncoding: ParameterEncoding {
    /// Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: EncryptJSONEncoding { EncryptJSONEncoding() }
    // MARK: Encoding
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters);
        urlRequest.httpBody = NKAESProvider.default().aes_decrypt(urlRequest.httpBody)
//            NKEncryptHandler.default.encrypt(httpBody: urlRequest.httpBody)
        return urlRequest
    }
    /// Encodes any JSON compatible object into a `URLRequest`.
    ///
    /// - Parameters:
    ///   - urlRequest: `URLRequestConvertible` value into which the object will be encoded.
    ///   - jsonObject: `Any` value (must be JSON compatible` to be encoded into the `URLRequest`. `nil` by default.
    ///
    /// - Returns:      The encoded `URLRequest`.
    /// - Throws:       Any `Error` produced during encoding.
    public func encode(_ urlRequest: URLRequestConvertible, withJSONObject jsonObject: Any? = nil) throws -> URLRequest {
        var urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: jsonObject);
        urlRequest.httpBody = NKAESProvider.default().aes_decrypt(urlRequest.httpBody)
        //NKEncryptHandler.default.encrypt(httpBody: urlRequest.httpBody)
        return urlRequest
    }
}
