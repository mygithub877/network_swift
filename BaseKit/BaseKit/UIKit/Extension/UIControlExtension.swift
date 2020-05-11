//
//  UIControlExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/11.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
private let BKControlHandlersKey = UnsafeRawPointer(bitPattern: "BKControlHandlersKey".hashValue)!
public typealias UIControlEventHandle = (_ sender:Any)->()

extension UIControl{

    private var events:[UInt:Set<_BKControlWrapper>]{
        set{
            objc_setAssociatedObject(self, BKControlHandlersKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            var events = objc_getAssociatedObject(self, BKControlHandlersKey) as? [UInt:Set<_BKControlWrapper>]
            if events == nil {
                events = [:]
                objc_setAssociatedObject(self, BKControlHandlersKey, events, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return events!
        }
    }
    public func addAction(event:UIControl.Event, action:@escaping UIControlEventHandle) {
        let key = event.rawValue
        var set = self.events[key]
        if set == nil {
            set = Set()
            self.events[key] = set;
        }
        set?.forEach({ (wrappper) in
            wrappper.callBack = nil
        })
        set?.removeAll()
        let wrapper = _BKControlWrapper()
        wrapper.event = event;
        wrapper.callBack = action;
        set?.insert(wrapper)
        self.addTarget(wrapper, action: #selector(_BKControlWrapper.invoke), for: event)
    }
    public func removeAction(event:UIControl.Event) {
        self.allTargets.forEach { (target) in
            if self.allControlEvents.contains(event){
                let actions = self.actions(forTarget: target, forControlEvent: event)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: event  )
                })
            }
        }
        self.events.removeValue(forKey: event.rawValue)
    }
    public func hasAction(event:UIControl.Event) -> Bool {
        if self.events[event.rawValue] != nil {
            return true
        }
        return false
    }
    public func removeAllActions(){
        self.allTargets.forEach { (target) in
            if self.allControlEvents.contains(.touchUpInside){
                let actions = self.actions(forTarget: target, forControlEvent: .touchUpInside)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchUpInside)
                })
            }else if self.allControlEvents.contains(.touchUpOutside){
                let actions = self.actions(forTarget: target, forControlEvent: .touchUpOutside)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchUpOutside)
                })
            }else if self.allControlEvents.contains(.touchDown){
                let actions = self.actions(forTarget: target, forControlEvent: .touchDown)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchDown)
                })
            }else if self.allControlEvents.contains(.touchDragOutside){
                let actions = self.actions(forTarget: target, forControlEvent: .touchDragOutside)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchDragOutside)
                })
            }else if self.allControlEvents.contains(.touchDragExit){
                let actions = self.actions(forTarget: target, forControlEvent: .touchDragExit)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchDragExit)
                })
            }else if self.allControlEvents.contains(.touchDragEnter){
                let actions = self.actions(forTarget: target, forControlEvent: .touchDragExit)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchDragExit)
                })
            }else if self.allControlEvents.contains(.touchCancel){
                let actions = self.actions(forTarget: target, forControlEvent: .touchCancel)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchCancel)
                })
            }else if self.allControlEvents.contains(.touchDownRepeat){
                let actions = self.actions(forTarget: target, forControlEvent: .touchDownRepeat)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .touchDownRepeat)
                })
            }else if self.allControlEvents.contains(.valueChanged){
                let actions = self.actions(forTarget: target, forControlEvent: .valueChanged)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .valueChanged)
                })
            }else if self.allControlEvents.contains(.primaryActionTriggered){
                let actions = self.actions(forTarget: target, forControlEvent: .primaryActionTriggered)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .primaryActionTriggered)
                })
            }else if self.allControlEvents.contains(.editingDidEnd){
                let actions = self.actions(forTarget: target, forControlEvent: .editingDidEnd)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .editingDidEnd)
                })
            }else if self.allControlEvents.contains(.editingChanged){
                let actions = self.actions(forTarget: target, forControlEvent: .editingChanged)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .editingChanged)
                })
            }else if self.allControlEvents.contains(.editingDidBegin){
                let actions = self.actions(forTarget: target, forControlEvent: .editingDidBegin)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .editingDidBegin)
                })
            }else if self.allControlEvents.contains(.editingDidEndOnExit){
                let actions = self.actions(forTarget: target, forControlEvent: .editingDidEndOnExit)
                actions?.forEach({ (action) in
                    self.removeTarget(target, action: Selector(action), for: .editingDidEndOnExit)
                })
            }
        }
        self.events.removeAll()
    }
}
private class _BKControlWrapper : NSObject {
    var event:UIControl.Event?
    var callBack:UIControlEventHandle?
    @objc func invoke(_ sender:Any) {
        if self.callBack != nil {
            self.callBack!(self)
        }
    }
}
