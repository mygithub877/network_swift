//
//  UIBarButtonItemExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/8.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    public var badgeText:String?{
        set{
            objc_setAssociatedObject(self, "badgeText", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, "badgeText") as? String
        }
    }
    public var barButton:UIControl?{
        set{
            objc_setAssociatedObject(self, "barButton", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, "barButton") as? UIControl
        }
    }
    public var badgeEnabled:Bool{
        set{
            objc_setAssociatedObject(self, "badgeEnabled", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return (objc_getAssociatedObject(self, "badgeEnabled") as? Bool) ?? false
        }

    }
    
    
}
extension UIBarButtonItem{
    public typealias UIBarButtonItemHandle = (_ sender:UIButton)->()
    public convenience init(_ title:String,action:UIBarButtonItemHandle?) {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        var color = UIBarButtonItem.appearance().tintColor
        if color == nil {
            color = .black
        }
        btn.setTitleColor(color, for: .normal)
        btn.setTitleColor(UIColor(white: 0.4, alpha: 0.35), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.sizeToFit()
        var aframe = btn.frame
        aframe.size.width += 10
        btn.frame = aframe
        self.init(customView:btn)
        objc_setAssociatedObject(self, "UIBarButtonItemBlock", action, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        btn.addTarget(self, action: #selector(_UIBarButtonItemAction), for: .touchUpInside)
    }
    public convenience init(_ image:UIImage,action:UIBarButtonItemHandle?) {
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.sizeToFit()
        var aframe = btn.frame
        aframe.size.width += 10
        btn.frame = aframe
        self.init(customView:btn)
        objc_setAssociatedObject(self, "UIBarButtonItemBlock", action, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        btn.addTarget(self, action: #selector(_UIBarButtonItemAction), for: .touchUpInside)
    }
    public convenience init(_ title:String,target:AnyClass, action:Selector) {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        var color = UIBarButtonItem.appearance().tintColor
        if color == nil {
            color = .black
        }
        btn.setTitleColor(color, for: .normal)
        btn.setTitleColor(UIColor(white: 0.4, alpha: 0.35), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.sizeToFit()
        var aframe = btn.frame
        aframe.size.width += 10
        btn.frame = aframe
        self.init(customView:btn)
        
    }
    public convenience init(_ image:UIImage,target:AnyClass, action:Selector) {
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.sizeToFit()
        var aframe = btn.frame
        aframe.size.width += 10
        btn.frame = aframe
        self.init(customView:btn)
    }
    @objc private func _UIBarButtonItemAction(sender:UIButton) -> Void {
        let block = objc_getAssociatedObject(self, "UIBarButtonItemBlock") as? UIBarButtonItemHandle
        if block != nil {
            block!(sender)
        }
    }
}
