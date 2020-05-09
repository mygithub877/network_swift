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
    public var interactivePopGestureRecognizerEnabled:Bool{
        set{
            objc_setAssociatedObject(self, AssociatedKey.interactive, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get{
            return (objc_getAssociatedObject(self, AssociatedKey.interactive) ?? false) as! Bool
        }
    }
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
    public var titleColor:UIColor?{
       set{
        objc_setAssociatedObject(self, AssociatedKey.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.titleColor) as? UIColor
       }
    }
    public var titleFont:UIFont?{
       set{
        objc_setAssociatedObject(self, AssociatedKey.titleFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.titleFont) as? UIFont
       }
    }
    public var barButtonTintColor:UIColor?{
       set{
           objc_setAssociatedObject(self, AssociatedKey.barButtonTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return objc_getAssociatedObject(self, AssociatedKey.barButtonTintColor) as? UIColor
       }
    }
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
    public var alpha:CGFloat{
       set{
           objc_setAssociatedObject(self, AssociatedKey.alpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       }
       get{
           return (objc_getAssociatedObject(self, AssociatedKey.alpha) ?? 0) as! CGFloat
       }
    }

    public func updateNavigationBar() -> Void {
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
