//
//  UIBarButtonItemExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/8.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    private struct AssociatedKey {
        static let badgeText = UnsafeRawPointer(bitPattern: "badgeText".hashValue)!
        static let barButton = UnsafeRawPointer(bitPattern: "barButton".hashValue)!
        static let badgeEnabled = UnsafeRawPointer(bitPattern: "badgeEnabled".hashValue)!
        static let UIBarButtonItemBlock = UnsafeRawPointer(bitPattern: "UIBarButtonItemBlock".hashValue)!
        static let badgeLabel = UnsafeRawPointer(bitPattern: "badgeLabel".hashValue)!

    }
    
    /// 设置 UIBarButtonItem角标
    public var badgeText:String?{
        set{
            objc_setAssociatedObject(self, AssociatedKey.badgeText, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard self.barButton != nil else {
                return
            }
            let lbl=objc_getAssociatedObject(self.barButton!, AssociatedKey.badgeLabel) as? UILabel;
            lbl?.text=newValue;
            var size:CGSize = .zero
            if newValue?.count == 0{
                if (newValue != nil) {
                    size=CGSize(width:8,height:8);
                    lbl?.isHidden=false;
                }else{
                    lbl?.isHidden=true;
                }
            }else{
                lbl?.isHidden=false;
                size = self.unReadLabelSize()
            }
            lbl?.layer.cornerRadius=size.height/2;
            lbl?.snp.updateConstraints({ (make) in
                make.size.equalTo(size)
            })
        }
        get{
            return objc_getAssociatedObject(self, AssociatedKey.badgeText) as? String
        }
    }
    public var barButton:UIControl?{
        set{
            if (self.barButton != nil && newValue == nil) {
                let lbl=objc_getAssociatedObject(self.barButton!, AssociatedKey.badgeLabel) as? UILabel;
                lbl?.removeFromSuperview()
                objc_setAssociatedObject(self.barButton!, AssociatedKey.badgeLabel, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            objc_setAssociatedObject(self, AssociatedKey.barButton, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard newValue != nil else {
                return
            }
            var lbl=objc_getAssociatedObject(newValue!, AssociatedKey.badgeLabel) as? UILabel;
            if lbl == nil {
                lbl = UILabel()
                lbl!.backgroundColor = .red
                lbl!.font = UIFont.systemFont(ofSize: 10)
                lbl!.textColor = .white
                lbl!.clipsToBounds = true
                lbl!.textAlignment = .center
                lbl!.text = self.badgeText
                newValue?.addSubview(lbl!)
                objc_setAssociatedObject(newValue!, AssociatedKey.badgeLabel, lbl!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                var size = self.unReadLabelSize()
                if (self.badgeText==nil) {
                    lbl!.isHidden=true;
                }else{
                    if (self.badgeText?.count==0) {
                        size=CGSize(width:8, height:8);
                    }
                }
                lbl!.layer.cornerRadius=size.height/2;
                let cls: AnyClass? = NSClassFromString("_UITAMICAdaptorView")
                if cls != nil && newValue?.isKind(of: cls!) != false {
                    lbl?.snp.makeConstraints({ (make) in
                        make.right.equalToSuperview().offset(2.5)
                        make.top.equalToSuperview().offset(-2.5)
                        make.size.equalTo(size)
                    })
                }else{
                    lbl?.snp.makeConstraints({ (make) in
                        make.right.equalToSuperview()
                        make.top.equalToSuperview()
                        make.size.equalTo(size)
                    })
                }
            }
        }
        get{
            return objc_getAssociatedObject(self, AssociatedKey.barButton) as? UIControl
        }
    }
    /// 设置 UIBarButtonItem角标有效性
    public var badgeEnabled:Bool{
        set{
            objc_setAssociatedObject(self, AssociatedKey.badgeEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return (objc_getAssociatedObject(self, AssociatedKey.badgeEnabled) as? Bool) ?? false
        }

    }
    private func unReadLabelSize() -> CGSize {
        guard self.barButton != nil else {
            return .zero
        }
        let lbl=objc_getAssociatedObject(self.barButton!, AssociatedKey.badgeLabel) as? UILabel;
        if (lbl != nil) {
            let size=NSString(string: lbl!.text ?? "").size(withAttributes: [NSAttributedString.Key.font : lbl!.font!])
            let maxHeight:CGFloat=15.0;
            let minWidth:CGFloat = maxHeight;
            var width:CGFloat=size.width+8.0;
            if (width < minWidth) {
                width = minWidth;
            }
            return CGSize(width:width, height:maxHeight);
        }else{
            return .zero;
        }

    }
    
}
extension UIBarButtonItem{
    public typealias UIBarButtonItemHandle = (_ sender:UIButton)->()
    
    /// 创建UIBarButtonItem，自定义UIButton
    /// - Parameters:
    ///   - title: title
    ///   - action: action
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
        objc_setAssociatedObject(self, AssociatedKey.UIBarButtonItemBlock, action, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        btn.addTarget(self, action: #selector(_UIBarButtonItemAction), for: .touchUpInside)
    }
    /// 创建UIBarButtonItem，自定义UIButton
    /// - Parameters:
    ///   - image: image
    ///   - action: action
    public convenience init(_ image:UIImage,action:UIBarButtonItemHandle?) {
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.sizeToFit()
        var aframe = btn.frame
        aframe.size.width += 10
        btn.frame = aframe
        self.init(customView:btn)
        objc_setAssociatedObject(self, AssociatedKey.UIBarButtonItemBlock, action, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        btn.addTarget(self, action: #selector(_UIBarButtonItemAction), for: .touchUpInside)
        
    }
    /// 创建UIBarButtonItem，自定义UIButton
    /// - Parameters:
    ///   - title: title
    ///   - action: action
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
    /// 创建UIBarButtonItem，自定义UIButton
    /// - Parameters:
    ///   - image: image
    ///   - action: action
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
        let block = objc_getAssociatedObject(self, AssociatedKey.UIBarButtonItemBlock) as? UIBarButtonItemHandle
        if block != nil {
            block!(sender)
        }
    }
}
