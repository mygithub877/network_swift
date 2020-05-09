//
//  BKNavigationViewController.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKNavigationViewController: UINavigationController{
    private var _defaultBarColor:UIColor?
    private var _defaultBarTitleColor:UIColor?
    private var _defaultBarTitleFont:UIFont?
    private var _display_count:Int?
    private var _percent:CGFloat?
    public var poping:Bool = false
    private var bar: BKNavigationBar{
        get{
            return self.navigationBar as! BKNavigationBar
        }
    }
    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: BKNavigationBar.self, toolbarClass: nil)
        self.bar.navigationController=self
        self.bar.color=BKNavigationBar.appearance().color;
        self.bar.titleColor=BKNavigationBar.appearance().titleColor;
        self.bar.titleFont=BKNavigationBar.appearance().titleFont;
        self.bar.backItemImage=BKNavigationBar.appearance().backItemImage;
        self.bar.tintColor=BKNavigationBar.appearance().tintColor;
        self.bar.barTintColor=BKNavigationBar.appearance().barTintColor;
        self.viewControllers=[rootViewController]
        self.modalPresentationStyle = .fullScreen;
    }
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: BKNavigationBar.self, toolbarClass: nil)
        self.bar.navigationController=self
        self.bar.color=BKNavigationBar.appearance().color;
        self.bar.titleColor=BKNavigationBar.appearance().titleColor;
        self.bar.titleFont=BKNavigationBar.appearance().titleFont;
        self.bar.backItemImage=BKNavigationBar.appearance().backItemImage;
        self.bar.tintColor=BKNavigationBar.appearance().tintColor;
        self.bar.barTintColor=BKNavigationBar.appearance().barTintColor;
        self.modalPresentationStyle = .fullScreen;
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.bar.navigationController=self
        self.bar.color=BKNavigationBar.appearance().color;
        self.bar.titleColor=BKNavigationBar.appearance().titleColor;
        self.bar.titleFont=BKNavigationBar.appearance().titleFont;
        self.bar.backItemImage=BKNavigationBar.appearance().backItemImage;
        self.bar.tintColor=BKNavigationBar.appearance().tintColor;
        self.bar.barTintColor=BKNavigationBar.appearance().barTintColor;
        self.modalPresentationStyle = .fullScreen;
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.bar.navigationController=self
        self.bar.color=BKNavigationBar.appearance().color;
        self.bar.titleColor=BKNavigationBar.appearance().titleColor;
        self.bar.titleFont=BKNavigationBar.appearance().titleFont;
        self.bar.backItemImage=BKNavigationBar.appearance().backItemImage;
        self.bar.tintColor=BKNavigationBar.appearance().tintColor;
        self.bar.barTintColor=BKNavigationBar.appearance().barTintColor;
        self.modalPresentationStyle = .fullScreen;
    }
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var titleAttr:[NSAttributedString.Key:Any] = [:]
        if self.bar.titleColor != nil {
            titleAttr[NSAttributedString.Key.foregroundColor]=self.bar.titleColor;
        }else{
            titleAttr[NSAttributedString.Key.foregroundColor]=UIColor.black;
        }
        if self.bar.titleFont != nil {
            titleAttr[NSAttributedString.Key.font]=self.bar.titleFont;
        }else{
            titleAttr[NSAttributedString.Key.font]=UIFont.systemFont(ofSize: 18);
        }
        self.bar.titleTextAttributes=titleAttr;

        _defaultBarColor = (self.bar.color != nil) ? self.bar.color : UIColor.white;
        _defaultBarTitleColor = (self.bar.titleColor != nil) ? self.bar.titleColor : UIColor.black;
        _defaultBarTitleFont = (self.bar.titleFont != nil) ? self.bar.titleFont:UIFont.systemFont(ofSize: 18);
        self.delegate = self
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle;
    }
    public func updateNavigationBar() {
        if let viewController=self.topViewController {
            if (viewController.navigationItem.barColor != nil) {
                self.bar.color=viewController.navigationItem.barColor;
            }else if (viewController.navigationItem.gradientColors != nil){
                self.bar.gradientColors=viewController.navigationItem.gradientColors;
            }else{
                //defult
                self.bar.color=_defaultBarColor;
            }
            if (viewController.navigationItem.titleColor != nil) {
                self.bar.titleColor=viewController.navigationItem.titleColor;
            }else{
                //default
                self.bar.titleColor=_defaultBarTitleColor;
            }
        }
    }

}

extension BKNavigationViewController{
    @objc private func Back() {
        self.popViewController(animated: true)
    }
    @objc public override func _updateInteractiveTransition(_ percent:CGFloat) -> Void {
        _percent = percent
        super._updateInteractiveTransition(percent)
        self.bar._updateTransitionPercent(percent: percent)
    }
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)){
            self.interactivePopGestureRecognizer!.isEnabled = false;
        }
        viewController.navigationItem.interactivePopGestureRecognizerEnabled=true;
        self.bar._navigationBeginPush()
        super.pushViewController(viewController, animated: animated)
    }
    public override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        self.bar._navigationBeginPopInitiallyInteractive(initiallyInteractive: vc?.transitionCoordinator?.initiallyInteractive ?? false)
        if (vc?.transitionCoordinator?.initiallyInteractive ?? false) {
            print("侧滑");
        }else{
            print("非侧滑");
        }
        return vc
    }
    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vcs = super.popToRootViewController(animated: animated)
        self.bar._navigationBeginPopInitiallyInteractive(initiallyInteractive: vcs?.last?.transitionCoordinator?.initiallyInteractive ?? false)
        if (vcs?.last?.transitionCoordinator?.initiallyInteractive ?? false) {
            print("侧滑");
        }else{
            print("非侧滑");
        }
        return vcs
    }
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vcs = super.popToViewController(viewController, animated: animated)
        self.bar._navigationBeginPopInitiallyInteractive(initiallyInteractive: vcs?.last?.transitionCoordinator?.initiallyInteractive ?? false)
        if (vcs?.last?.transitionCoordinator?.initiallyInteractive ?? false) {
            print("侧滑");
        }else{
            print("非侧滑");
        }
        return vcs
    }
}

extension BKNavigationViewController: UINavigationControllerDelegate{
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.poping=false;
        if (navigationController.responds(to: #selector(getter: interactivePopGestureRecognizer))) {
            if (viewController.navigationItem.interactivePopGestureRecognizerEnabled==false) {
                navigationController.interactivePopGestureRecognizer?.isEnabled = false;
            }else{
                navigationController.interactivePopGestureRecognizer?.isEnabled = true;
            }
        }
        if (navigationController.viewControllers.count == 1) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false;
            navigationController.interactivePopGestureRecognizer?.delegate = nil;
        }
        let fromVC = self.topViewController?.transitionCoordinator?.viewController(forKey: .from)
        let toVC = self.topViewController?.transitionCoordinator?.viewController(forKey: .to)
        guard fromVC != nil && toVC != nil else {return}
        if self.viewControllers.contains(fromVC!) == false{
            self.bar._navigationTransitionDidPop()
            if toVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionLeftColor(color: toVC?.navigationItem.barColor)
            }else if toVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionLeftGradientColors(gradientColors: toVC!.navigationItem.gradientColors!)
            }else if toVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionLeftImage(image: toVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionLeftColor(color: _defaultBarColor)
            }
            
            if fromVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionRightColor(color: fromVC?.navigationItem.barColor)
            }else if fromVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionRightGradientColors(gradientColors: fromVC!.navigationItem.gradientColors!)
            }else if fromVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionRightImage(image: fromVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionRightColor(color: _defaultBarColor)
            }

        }else{
            self.bar._navigationTransitionDidPush()
            if fromVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionLeftColor(color: fromVC?.navigationItem.barColor)
            }else if fromVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionLeftGradientColors(gradientColors: fromVC!.navigationItem.gradientColors!)
            }else if fromVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionLeftImage(image: fromVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionLeftColor(color: _defaultBarColor)
            }
            
            if toVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionRightColor(color: toVC?.navigationItem.barColor)
            }else if toVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionRightGradientColors(gradientColors: toVC!.navigationItem.gradientColors!)
            }else if toVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionRightImage(image: toVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionRightColor(color: _defaultBarColor)
            }

        }
    }
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.poping=true;
        if (viewController != navigationController.viewControllers.first) {
            if (viewController.navigationItem.leftBarButtonItem==nil) {
                if (!viewController.navigationItem.hidesBackButton) {
                    viewController.navigationItem.leftBarButtonItem=UIBarButtonItem(image: self.bar.backItemImage, style: .done, target: self, action: #selector(Back))
                }
            }
        }
        let fromVC = self.topViewController?.transitionCoordinator?.viewController(forKey: .from)
        let toVC = self.topViewController?.transitionCoordinator?.viewController(forKey: .to)
        if let topVC = self.topViewController,let coor = topVC.transitionCoordinator {
            coor.notifyWhenInteractionChanges {[weak self] (context) in
                if context.isCancelled {
                    self?.bar._updateTransitionPercent(percent: -1.0)
                    let vc = context.viewController(forKey: .from)
                    self?.bar.color = vc?.navigationItem.barColor
                    if #available(iOS 13.0, *) {
                        self?.navigationController(navigationController, willShow: vc!, animated: animated)
                    }
                }else{
                    self?.bar._updateTransitionPercent(percent: 1.0)
                }
            }
        }
        if (viewController.navigationItem.barColor != nil) {
            self.bar.color=viewController.navigationItem.barColor;
        }else if (viewController.navigationItem.gradientColors != nil){
            self.bar.gradientColors=viewController.navigationItem.gradientColors;
        }else if (viewController.navigationItem.barImage != nil) {
            self.bar.backgroundImage=viewController.navigationItem.barImage;
        }else{
            //defult
            self.bar.color=_defaultBarColor;
        }
        if (viewController.navigationItem.titleColor != nil) {
            self.bar.titleColor=viewController.navigationItem.titleColor;
        }else{
            //default
            self.bar.titleColor=_defaultBarTitleColor;
        }
        guard fromVC != nil && toVC != nil else {return}
        if  self.viewControllers.contains(fromVC!) == false{
            if toVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionLeftColor(color: toVC?.navigationItem.barColor)
            }else if toVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionLeftGradientColors(gradientColors: toVC!.navigationItem.gradientColors!)
            }else if toVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionLeftImage(image: toVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionLeftColor(color: _defaultBarColor)
            }
            
            if fromVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionRightColor(color: fromVC?.navigationItem.barColor)
            }else if fromVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionRightGradientColors(gradientColors: fromVC!.navigationItem.gradientColors!)
            }else if fromVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionRightImage(image: fromVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionRightColor(color: _defaultBarColor)
            }
            self.bar._navigationTransitionWillPop()
        }else{
            if fromVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionLeftColor(color: fromVC?.navigationItem.barColor)
            }else if fromVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionLeftGradientColors(gradientColors: fromVC!.navigationItem.gradientColors!)
            }else if fromVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionLeftImage(image: fromVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionLeftColor(color: _defaultBarColor)
            }
            
            if toVC?.navigationItem.barColor != nil {
                self.bar._updateTransitionRightColor(color: toVC?.navigationItem.barColor)
            }else if toVC?.navigationItem.gradientColors != nil{
                self.bar._updateTransitionRightGradientColors(gradientColors: toVC!.navigationItem.gradientColors!)
            }else if toVC?.navigationItem.barImage != nil{
                self.bar._updateTransitionRightImage(image: toVC!.navigationItem.barImage!)
            }else{
                self.bar._updateTransitionRightColor(color: _defaultBarColor)
            }
            self.bar._navigationTransitionWillPush()
        }

    }
}
extension BKNavigationViewController: UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer{
            if (self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first) {
                return false;
            }else if (self.visibleViewController?.navigationItem.interactivePopGestureRecognizerEnabled == false){
                return false;
            }
        }
        return true;
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
    }
}
