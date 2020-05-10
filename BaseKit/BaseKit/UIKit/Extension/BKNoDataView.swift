//
//  BKNoDataView.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

class BKNoDataView: UIView {

    public var title:String = "" {
        didSet{
            
        }
    }
    public var image:UIImage?{
        didSet{
            self.imageView.image = image
            self.imageView.sizeToFit()
            self.sizeToFit()
        }
    }
    public var errorCode:Int = 0 {
        didSet{
            switch errorCode {
                case NSURLErrorNotConnectedToInternet:
                    self.title = "網路連接失敗";
                    break;
                case NSURLErrorTimedOut:
                    self.title = "網路請求超時";
                    break;
                case NSURLErrorNetworkConnectionLost:
                    self.title = "網路連接失敗";
                    break;
                case NSURLErrorCannotConnectToHost:
                    self.title = "無法連結到伺服器";
                    break;
                default:
                    break;
            }

        }
    }
    public private(set) var button = UIButton()
    public private(set) var imageView = UIImageView()
    public private(set) var titleLabel = UILabel()
    public var buttonAction:((_ sender:UIButton)->())?
    public var centerYConstrait:NSLayoutConstraint?
    public var centerXConstrait:NSLayoutConstraint?
    
}
