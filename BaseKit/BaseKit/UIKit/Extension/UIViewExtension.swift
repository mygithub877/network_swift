//
//  UIViewExtension.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
extension UIView{
    public var minX:CGFloat{
        set{
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        get{
            return self.frame.minX
        }
    }
    public var maxX:CGFloat{
        get{
            return self.frame.maxX
        }
    }
    public var minY:CGFloat{
        set{
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        get{
            return self.frame.minY
        }
    }
    public var maxY:CGFloat{
        get{
            return self.frame.maxY
        }
    }
    public var width:CGFloat{
        set{
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
        get{
            return self.frame.width
        }
    }
    public var height:CGFloat{
        set{
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
        get{
            return self.frame.height
        }
    }
    public var screenFrame:CGRect{
        get{
            var x:CGFloat = 0
            var y:CGFloat = 0
            var view:UIView? = self
            var i = 0
            while view != nil {
                view = view?.superview
                x += view?.minX ?? 0;
                y += view?.minY ?? 0;
                if view is UIScrollView {
                    if i>0 {
                        let scrollView = view as! UIScrollView
                        x -= scrollView.contentOffset.x;
                        y -= scrollView.contentOffset.y;
                    }
                }
                i += 1
            }
            return CGRect(x: x, y: y, width: self.width, height: self.height)
        }
    }
    public var viewController:UIViewController{
        get{
            var responder = self.next
            while responder?.isKind(of: UIViewController.self) == false {
                responder = responder?.next
            }
            return responder as! UIViewController
        }
    }
    public func removeAllSubViews() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
}
extension UIView{
    public enum CornerRadius {
        case top(_ value:CGFloat)
        case bottom(_ value:CGFloat)
        case left(_ value:CGFloat)
        case right(_ value:CGFloat)
        case topRight(_ value:CGFloat)
        case topLeft(_ value:CGFloat)
        case bottomRight(_ value:CGFloat)
        case bottomLeft(_ value:CGFloat)
        case topRightBottomLeft(_ value:CGFloat)
        case topLeftBottomRight(_ value:CGFloat)
    }
    public var cornerRadius:CornerRadius?{
        set{
            var maskPath:UIBezierPath?
            switch newValue {
            case .top(let value):
                let corners = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii: CGSize(width: value, height: value))
            case .bottom(let value):
                let corners = UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii: CGSize(width: value, height: value))
            case .left(let value):
                let corners = UIRectCorner.topLeft.rawValue | UIRectCorner.bottomLeft.rawValue
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii: CGSize(width: value, height: value))
            case .right(let value):
                let corners = UIRectCorner.topRight.rawValue | UIRectCorner.topRight.rawValue
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii: CGSize(width: value, height: value))
            case .topRight(let value):
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .topRight, cornerRadii: CGSize(width: value, height: value))
            case .topLeft(let value):
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: value, height: value))
            case .bottomRight(let value):
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .bottomRight, cornerRadii: CGSize(width: value, height: value))
            case .bottomLeft(let value):
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .bottomLeft, cornerRadii: CGSize(width: value, height: value))
            case .topRightBottomLeft(let value):
                let corners = UIRectCorner.bottomLeft.rawValue | UIRectCorner.topRight.rawValue
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii: CGSize(width: value, height: value))
            case .topLeftBottomRight(let value):
                let corners = UIRectCorner.topLeft.rawValue | UIRectCorner.bottomRight.rawValue
                maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii: CGSize(width: value, height: value))
            default:
                break
            }
            if maskPath != nil {
                let maskLayer = CAShapeLayer()
                maskLayer.frame = self.bounds;
                maskLayer.path = maskPath!.cgPath;
                self.layer.mask = maskLayer;
            }
        }
        get{
            return nil
        }
    }
    
}