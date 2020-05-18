//
//  BKTransition.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKTransition: NSObject {
    public var presentRect:CGRect = .zero
    public var containerBackgroundColor:UIColor = .init(white: 0, alpha: 0.33)
    public var animateDuration:TimeInterval = 0.35
    public var containerBackgroundHitTestEvent:((_ view:UIView,_ point:CGPoint,_ event:UIEvent)->UIView)?
    public var orientation:UIInterfaceOrientation?
    public var presentAnimation:((_ transitionContext:UIViewControllerContextTransitioning)->Void)?
    public var dismissAnimation:((_ transitionContext:UIViewControllerContextTransitioning)->Void)?

    private weak var _presentController:_BKPresentController?
    private var _isPresent:Bool = false
    public var containerBackgroundView:UIView?{
        return _presentController?.backgroundView
    }
    
}
extension BKTransition:UIViewControllerTransitioningDelegate{
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentVC = _BKPresentController(presentedViewController: presented, presenting: presenting)
        presentVC.presentRect=presentRect;
        presentVC.containerBackgroundColor=containerBackgroundColor;
        presentVC.containerBackgroundHitTestEvent = self.containerBackgroundHitTestEvent;
        presentVC.orientation=self.orientation;
        _presentController = presentVC;
        return presentVC
    }
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _isPresent=true
        return self;
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _isPresent=false
        return self;
    }
}
extension BKTransition :UIViewControllerAnimatedTransitioning{
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (transitionContext?.isAnimated == true) {
            return animateDuration;
        }else{
            return 0.0;
        }
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if _isPresent {
            if presentAnimation != nil {
                presentAnimation!(transitionContext)
            }else{
                guard let toView = transitionContext.view(forKey: .to) else { return }
                let vc = transitionContext.viewController(forKey: .to)
                vc?.viewWillAppear(true)
                transitionContext.containerView.addSubview(toView)
                toView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
                UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
                    toView.frame=self.presentRect
                    self._presentController = nil
                }) { (a) in
                    transitionContext.completeTransition(true)
                    vc?.viewDidAppear(true)
                }
            }
        }else{
            if dismissAnimation != nil {
                dismissAnimation!(transitionContext)
            }else{
                let vc = transitionContext.viewController(forKey: .from)
                vc?.viewWillDisappear(true)
                let fromView = transitionContext.view(forKey: .from)
                UIView.animate(withDuration: animateDuration, delay: 0, options: .curveEaseInOut, animations: {
                    fromView?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.presentRect.size.height)
                    self._presentController = nil
                }) { (a) in
                    transitionContext.completeTransition(true)
                    vc?.viewDidDisappear(true)
                }
            }
        }
    }
    
    
}
class _BKPresentController:UIPresentationController{
    var presentRect:CGRect = .zero
    var containerBackgroundColor:UIColor = .init(white: 0, alpha: 0.33)
    var containerBackgroundHitTestEvent:((_ view:UIView,_ point:CGPoint,_ event:UIEvent)->UIView)?
    var backgroundView:_BKPresentContainerBackground?
    var landscapView:UIView?
    var orientation:UIInterfaceOrientation?
}
class _BKPresentContainerBackground:UIView{
    var containerBackgroundHitTestEvent:((_ view:UIView,_ point:CGPoint,_ event:UIEvent)->UIView)?
}
