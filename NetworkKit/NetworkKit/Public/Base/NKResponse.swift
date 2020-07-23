//
//  NKResponse.swift
//  NetworkKit
//
//  Created by wenjie liu on 2020/7/16.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import HandyJSON
import Alamofire
public class NKResponse: HandyJSON {
    public var isSuccess:Bool = false
    public var code:Int = 0
    public var response:Any?
    public var error:NKError?
    
    public private(set) var URL:URL?
    public private(set) var method:String?
    public private(set) var header:NSDictionary?
    public private(set) var statusCode:Int?;
    
    required public init() {}

    internal var data:AFDataResponse<Any>?{
        didSet{
            self.URL=self.data?.request?.url;
            self.method=self.data?.request?.method?.rawValue;
            self.header=(self.data?.response?.allHeaderFields ?? [:]) as NSDictionary;
            self.statusCode=self.data?.response?.statusCode;
        }
    }
    public var description: String {
        return data?.description ?? "";
    }
    public var debugDescription: String {
        return data?.debugDescription ?? "";
    }
}
