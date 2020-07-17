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
    
    public var URL:URL?
    public var method:String?
    public var header:NSDictionary?
    public var statusCode:Int?;
    
    required public init() {}

    internal var data:AFDataResponse<Any>?
    public var description: String {
        return data?.description ?? "";
    }
    public var debugDescription: String {
        return data?.debugDescription ?? "";
    }
}
