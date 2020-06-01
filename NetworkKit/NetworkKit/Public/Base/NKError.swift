//
//  NKError.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/5/31.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import Foundation
enum NKError {
    case notConnectedToInternet
    case timeout
    case cannotConnectToHost
    case other
    var statusCode:Int{
        return 200
    }
    var errorDescription:String{
        return ""
    }
    var isNetworkError:Bool{
        return false
    }
    var isHTTPError:Bool{
        return false
    }
    
    
}
