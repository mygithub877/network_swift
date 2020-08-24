//
//  NKAuthSession.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/6/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class NKAuthSession: NKBaseSession {
    public static let `default` = NKAuthSession()
    
    public func fetchVersion(completion:NKSessionCompletion?)  {
        let url = REST.USER.APP_VERSION(platform: 2, app: 1).URL
        self.GET(url: url) { (response) in
            if !response.isSuccess {
                DLog("\(String(describing: response.error?.errorDescription))")
            }
            if completion != nil{
                completion!(response);
            }
        }
    }
    public func sendCaptcha(phone:String,code:String,completion:NKSessionCompletion?)  {
        let url = REST.USER.CAPTCHA_SEND.URL
        
        self.POST_SEC(url: url,parameters: ["mobile":phone,"code":code,"deviceId":"udid","type":"user:login"]) { (response) in
            if !response.isSuccess {
                DLog("\(String(describing: response.error?.errorDescription))")
            }
            if completion != nil{
                completion!(response);
            }
        }
    }
}
