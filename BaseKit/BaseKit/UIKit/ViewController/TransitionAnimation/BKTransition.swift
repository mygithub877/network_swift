//
//  BKTransition.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

/// 自定义模态动画代理类
public class BKTransition: NSObject {
    
    /// 模态显示Rect
    public var presentRect:CGRect = .zero
    
    /// 模态容器背景颜色（非模态视图背景）
    public var containerBackgroundColor:UIColor = .init(white: 0, alpha: 0.33)
    
    /// 动画时间
    public var animateDuration:TimeInterval = 0.35
    
    /// 背景视图响应事件HitTest回调
    public var containerBackgroundHitTestEvent:((_ view:UIView,_ point:CGPoint,_ event:UIEvent)->UIView)?
    
    /// 点击背景时是否dismiss
    public var dismissWhenTouch:Bool = false{
        didSet{
            _presentController?.dismissWhenTouch=dismissWhenTouch
        }
    }
    
    /// 屏幕方向
    public var orientation:UIInterfaceOrientation?
    
    /// 自定义弹出动画
    public var presentAnimation:((_ transitionContext:UIViewControllerContextTransitioning)->Void)?
    
    /// 自定义消失动画
    public var dismissAnimation:((_ transitionContext:UIViewControllerContextTransitioning)->Void)?

    /// 背景视图
    public var containerBackgroundView:UIView?{
        return _presentController?.backgroundView
    }
    private weak var _presentController:_BKPresentController?
    private var _isPresent:Bool = false
    
    
}
extension BKTransition:UIViewControllerTransitioningDelegate{
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentVC = _BKPresentController(presentedViewController: presented, presenting: presenting)
        presentVC.dismissWhenTouch=dismissWhenTouch
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
    var dismissWhenTouch:Bool = false
    var presentRect:CGRect = .zero
    var containerBackgroundColor:UIColor = .init(white: 0, alpha: 0.33){
        didSet{
            self.backgroundView.backgroundColor=containerBackgroundColor
        }
    }
    var containerBackgroundHitTestEvent:((_ view:UIView,_ point:CGPoint,_ event:UIEvent)->UIView)?{
        didSet{
            self.backgroundView.containerBackgroundHitTestEvent=containerBackgroundHitTestEvent
        }
    }
    var backgroundView=_BKPresentContainerBackground()
    var landscapView:UIView = UIView()
    var orientation:UIInterfaceOrientation?
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.landscapView.frame=UIScreen.main.bounds
        self.backgroundView.frame=UIScreen.main.bounds
        self.backgroundView.backgroundColor=containerBackgroundColor
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapAction)))
    }
    @objc func backgroundTapAction(_ sender:UITapGestureRecognizer) {
        if dismissWhenTouch {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    override func containerViewWillLayoutSubviews() {
        self.presentedView?.frame = self.presentRect;
        self.containerView?.insertSubview(self.landscapView, at: 0)
        self.landscapView.insertSubview(self.backgroundView, at: 0)
        if self.orientation?.isLandscape ?? false {
            let transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi*0.5))
            landscapView.frame = CGRect(x: SCREEN.WIDTH/2-SCREEN.HEIGHT/2, y: SCREEN.HEIGHT/2-SCREEN.WIDTH/2, width: SCREEN.HEIGHT, height: SCREEN.WIDTH)
            landscapView.transform=transform
            self.backgroundView.frame=CGRect(x: 0, y: 0, width: SCREEN.HEIGHT, height: SCREEN.WIDTH)
        }
    }
    override func containerViewDidLayoutSubviews() {
        let subviews = self.containerView?.subviews
        if subviews?.count == 2 && self.presentedView != nil{
            self.landscapView.addSubview(self.presentedView!)
        }
    }
}
class _BKPresentContainerBackground:UIView{
    var containerBackgroundHitTestEvent:((_ view:UIView,_ point:CGPoint,_ event:UIEvent)->UIView)?
}
