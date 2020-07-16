//
//  NKResponse.swift
//  NetworkKit
//
//  Created by wenjie liu on 2020/7/16.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import HandyJSON
class NKResponse: HandyJSON {
    var success:Bool = false
    var code:Int = 0
    var response:Any?
    var error:NKError?
    required init() {}
}
