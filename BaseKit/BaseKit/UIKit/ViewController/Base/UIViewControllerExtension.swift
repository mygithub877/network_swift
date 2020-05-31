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
    
    /// 便利构造UIAlert弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - msg: 内容
    ///   - buttons: 按钮标题
    ///   - handle: 事件回调
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
    
    /// 便利构造富文本UIAlert弹窗
    /// - Parameters:
    ///   - attributedTitle: 富文本标题
    ///   - attributedMsg: 富文本内容
    ///   - buttons: 按钮
    ///   - handle: 事件回调
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
    
    /// 便利弹窗类型
    public enum AlertStyle:Int {
        case Style1 = 0 ///取消和确定按钮
        case Style2 = 1 ///确定按钮
        case Style3 = 2 ///知道了按钮
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
    
    /// 便利自动影藏提示弹窗
    /// - Parameters:
    ///   - text: 内容
    ///   - dismiss: 自动消失回调
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
    
    /// 便利自动影藏提示弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - text: 内容
    ///   - dismiss: 自动消失回调
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
    
    /// 便利构建UIActionSheet
    /// - Parameters:
    ///   - title: 标题
    ///   - msg: 内容
    ///   - cancel: 取消按钮
    ///   - buttons: 其他按钮
    ///   - handle: 事件回调
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
    
    /// 当前导航栈里控制器对应的下一个控制器
    /// - Returns: 控制器
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
    
    /// 当前导航栈里控制器对应的上一个控制器
    /// - Returns: 控制器
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
    
    /// dismiss当前所有的模态控制器
    /// - Parameters:
    ///   - flag: 动画
    ///   - completion: 完成回调
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
