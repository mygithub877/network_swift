//
//  NKAuthSession.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/6/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

class NKAuthSession: NKBaseSession {
    func login()  {
        let url = REST.USER.APP_VERSION(platform: 2, app: 1).URL
        self .GET(url: url) { (response) in
            
        }
    }
}
