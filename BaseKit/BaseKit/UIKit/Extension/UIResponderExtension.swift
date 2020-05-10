//
//  UIResponderExtension.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
extension UIResponder{
    /**
    *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
    *
    *  @param eventName 发生的事件名称
    *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
    *
    *  e.g 比如一个view中有点击事件或其他响应事件需要控制器或者他的父视图做出响应，而此时既不想用通知又不想用代理和block,则可以使用此方式，此方式相比较通知来说比较安全，通知可以一对多的去发送 有一定的不可预知性 但此方法只对当前响应链中起效，比如在一个cell中调用此方法，他只在当前控制器响应链中响应。不会影响到其他页面
    */
    public func routerEvent(name:String,userInfo:Any?) -> Void {
        self.next?.routerEvent(name: name, userInfo: userInfo)
    }
}
