//
//  UINavigationItemExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/9.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

extension UINavigationItem{
    private struct AssociatedKey {
        static let interactive = UnsafeRawPointer(bitPattern: "interactivePopGestureRecognizerEnabled".hashValue)!
        static let barImage = UnsafeRawPointer(bitPattern: "barImage".hashValue)!
        static let barColor = UnsafeRawPointer(bitPattern: "barColor".hashValue)!
        static let gradientColors = UnsafeRawPointer(bitPattern: "gradientColors".hashValue)!
        static let titleColor = UnsafeRawPointer(bitPattern: "titleColor".hashValue)!
        static let titleFont = UnsafeRawPointer(bitPattern: "titleColor".hashValue)!
        static let barButtonTintColor = UnsafeRawPointer(bitPattern: "barButtonTintColor".hashValue)!
        static let translucent = UnsafeRawPointer(bitPattern: "translucent".hashValue)!
        static let alpha = UnsafeRawPointer(bitPattern: "alpha".hashValue)!
    }
    
    /// 设置单个页面侧滑手势有效性
    public var interactivePopGestureRecognizerEnabled:Bool{
        set{
            objc_setAssociatedObject(self, AssociatedKey.interactive, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get{
            return (objc_getAssociatedObject(self, AssociatedKey.interactive) ?? false) as! Bool
        }
    }
    
    /// 设置单个页面导航栏图片
    public var barImage:UIImage?{
        set{
            objc_setAssociatedObject(self, AssociatedKey.barImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, AssociatedKey.gradientColors, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC);
            objc_setAssociatedObject(self, AssociatedKey.barColor, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        get{
            return objc_getAssociatedObject(self, AssociatedKey.barImage) as? UIImage
        }
    }
    
    /// 设置单个页面导航栏背景色
    public var barColor:UIColor?{
       set{
            objc_setAssociatedObject(self, AssociatedKey.barColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, AssociatedKey.gradientColors, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC);
            objc_setAssociatedObject(self, AssociatedKey.barImage, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC);
       }
       get{
        let rs=objc_getAssociatedObject(self, AssociatedKey.barColor)
           return rs as? UIColor
       }
    }
    
    /// 设置单个页面导航栏渐变色
    public var gradientColors:[UIColor]?{
       set{
        objc_setAssociatedObject(self, AssociatedKey.gradientColors, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, AssociatedKey.barColor, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, AssociatedKey.barImage, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.gradientColors) as? [UIColor]
       }
    }
    
    /// 设置单个页面导航栏标题颜色
    public var titleColor:UIColor?{
       set{
        objc_setAssociatedObject(self, AssociatedKey.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.titleColor) as? UIColor
       }
    }
    
    /// 设置单个页面导航栏标题字体
    public var titleFont:UIFont?{
       set{
        objc_setAssociatedObject(self, AssociatedKey.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.titleFont) as? UIFont
       }
    }
    /// 设置单个页面导航栏按钮颜色
    public var barButtonTintColor:UIColor?{
       set{
           objc_setAssociatedObject(self, AssociatedKey.barButtonTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.barButtonTintColor) as? UIColor
       }
    }
    
    /// 设置单个页面导航栏高斯效果
    public var translucent:Bool{
       set{
           objc_setAssociatedObject(self, AssociatedKey.translucent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        let nav=self.value(forKey: "_navigationBar") as? BKNavigationBar;
        nav?.isTranslucent=newValue;
       }
       get{
           return (objc_getAssociatedObject(self, AssociatedKey.translucent) ?? false) as! Bool
       }
    }
    
    /// 设置单个页面导航栏透明度
    public var alpha:CGFloat{
       set{
           objc_setAssociatedObject(self, AssociatedKey.alpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return (objc_getAssociatedObject(self, AssociatedKey.alpha) ?? 0) as! CGFloat
       }
    }
    
    /// 更新导航栏样式
    public func updateNavigationBar() {
        let nav=self.value(forKey: "_navigationBar") as? BKNavigationBar;
        if (self.barColor != nil) {
            nav?.color=self.barColor;
        }else if (self.gradientColors != nil){
            nav?.gradientColors=self.gradientColors;
        }else if (self.barImage != nil){
            nav?.backgroundImage=self.barImage;
        }
        if (self.barButtonTintColor != nil) {
            nav?.tintColor=self.barButtonTintColor;
        }
        if (self.titleFont != nil) {
            nav?.titleFont=self.titleFont;
        }
        if (self.titleColor != nil) {
            nav?.titleColor=self.titleColor;
        }
    }
}
