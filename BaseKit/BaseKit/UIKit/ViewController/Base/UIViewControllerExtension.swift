//
//  UIViewControllerExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/4/30.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
public typealias ButtonHandle = (_ index:Int)->()
extension UIViewController {
    public func showAlert(_ title:String?, msg:String?, buttons:String..., handle:ButtonHandle? = nil){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        var index = 0
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: {[index] (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        self.present(alert, animated: true, completion: nil);
    }
    public func showAlert(_ attributedTitle:NSAttributedString?, attributedMsg:NSAttributedString?, buttons:String..., handle:ButtonHandle? = nil){
        let alert = UIAlertController(title: attributedTitle?.string, message: attributedMsg?.string, preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMsg, forKey: "attributedMessage")
        var index = 0
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: {[index] (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        self.present(alert, animated: true, completion: nil);
    }
    
    public enum AlertStyle:Int {
        case Style1 = 0
        case Style2 = 1
        case Style3 = 2
    }
    public func showAlert(_ style:AlertStyle,title: String,  handle: ButtonHandle? = nil) -> Void {
        switch style {
        case .Style1:
            self.showAlert(title, msg:nil, buttons: "取消","确定", handle: handle)
        case .Style2:
            self.showAlert(title, msg:nil, buttons: "确定", handle: handle)
        case .Style3:
            self.showAlert(title,msg:nil, buttons: "我知道了", handle: handle)
        }
    }
    public typealias ToastHandle = ()->()
    public func showToast(_ text:String, dismiss:ToastHandle? = nil){
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        var time = 1.5
        if text.count>8 && text.count < 15 {
            time = 2.0
        }else if text.count >= 15 {
            time = 2.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+time) {
            alert.dismiss(animated: true, completion: dismiss)
        }
    }
    public func showToast(_ title:String, text:String, dismiss:ToastHandle? = nil){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        var time = 1.5
        if text.count>8 && text.count < 15 {
            time = 2.0
        }else if text.count >= 15 {
            time = 2.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+time) {
            alert.dismiss(animated: true, completion: dismiss)
        }
    }
    
}
extension UIViewController {
    
    public func showSheet(_ title:String?, msg:String?, cancel:String?, buttons:String..., handle:ButtonHandle? = nil){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        var index = 0
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: {[index] (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        if cancel != nil {
            alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: {[index] (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
        }
        self.present(alert, animated: true, completion: nil);
    }
    public func showSheet(_ attributedTitle:NSAttributedString?, attributedMsg:NSAttributedString?,cancel:String?, buttons:String..., handle:ButtonHandle? = nil){
        let alert = UIAlertController(title: attributedTitle?.string, message: attributedMsg?.string, preferredStyle: .actionSheet)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMsg, forKey: "attributedMessage")
        var index = 0
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: {[index] (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        if cancel != nil {
            alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: {[index] (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
        }
        self.present(alert, animated: true, completion: nil);
    }    
}
extension UIViewController {
    public func nextViewController() -> UIViewController? {
        if (self.navigationController == nil) {
            return nil;
        }
        var index = 0
        var nexIndex:Int?
        self.navigationController!.viewControllers.forEach({ (vc) in
            if vc == self {
                nexIndex = index+1
            }
            index += 1
        })
        if nexIndex == nil{
            return nil
        }else if nexIndex! >= self.navigationController!.viewControllers.count{
            return nil
        }else{
            return self.navigationController!.viewControllers[nexIndex!]
        }
    }
    public func previousViewController() -> UIViewController? {
        if (self.navigationController == nil) {
            return nil;
        }
        var index = 0
        var preIndex:Int?
        self.navigationController!.viewControllers.forEach({ (vc) in
            if vc == self {
                preIndex = index-1
            }
            index += 1
        })
        if preIndex == nil{
            return nil
        }else if preIndex! < 0{
            return nil
        }else{
            return self.navigationController!.viewControllers[preIndex!]
        }
    }
    public func dismissAll(animated flag: Bool, completion: (() -> Void)? = nil){
        self.presentedViewController?.dismiss(animated: flag, completion: {
            if self.presentedViewController != nil {
                self.dismissAll(animated: flag, completion: completion)
            }else{
                if completion != nil {
                    completion!()
                }
            }
        })
    }
    
}
