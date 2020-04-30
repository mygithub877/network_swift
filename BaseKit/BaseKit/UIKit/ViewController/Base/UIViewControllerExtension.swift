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
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: { (action) in
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
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: { (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        self.present(alert, animated: true, completion: nil);
    }
    public func showAlert1(_ title: String,  handle: ButtonHandle? = nil) -> Void {
        self.showAlert(title, msg:nil, buttons: "取消","确定", handle: handle)
    }
    public func showAlert1(message msg: String,  handle: ButtonHandle? = nil) -> Void {
        self.showAlert(nil, msg:msg, buttons: "取消","确定", handle: handle)
    }
    public func showAlert2(_ title: String,  handle: ButtonHandle? = nil) -> Void {
        self.showAlert(title, msg:nil, buttons: "确定", handle: handle)
    }
    public func showAlert2(message msg: String,  handle: ButtonHandle? = nil) -> Void {
        self.showAlert(nil,msg:msg, buttons: "确定", handle: handle)
    }
    public func showAlert3(_ title: String,  handle: ButtonHandle? = nil) -> Void {
        self.showAlert(title,msg:nil, buttons: "我知道了", handle: handle)
    }
    public func showAlert3(message msg: String,  handle: ButtonHandle? = nil) -> Void {
        self.showAlert(nil,msg:msg, buttons: "我知道了", handle: handle)
    }
    
}
extension UIViewController {
    
    public func showSheet(_ title:String?, msg:String?, cancel:String?, buttons:String..., handle:ButtonHandle? = nil){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        var index = 0
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: { (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        if cancel != nil {
            alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { (action) in
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
            alert.addAction(UIAlertAction(title: btn, style: .default, handler: { (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
            index += 1
        }
        if cancel != nil {
            alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { (action) in
                if handle != nil{
                    handle!(index)
                }
            }))
        }
        self.present(alert, animated: true, completion: nil);
    }    
}
