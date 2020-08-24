//
//  BKNavigationBar.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
fileprivate let bar = BKNavigationBar()
private protocol _BarPrivateProtocol : NSObject{
    var navigationController:UINavigationController? { get set }
    func _updateTransitionPercent(percent:CGFloat)
    func _updateTransitionLeftImage(image:UIImage)
    func _updateTransitionLeftColor(color:UIColor?)
    func _updateTransitionLeftGradientColors(gradientColors:[UIColor])
    func _updateTransitionRightImage(image:UIImage)
    func _updateTransitionRightColor(color:UIColor?)
    func _updateTransitionRightGradientColors(gradientColors:[UIColor])
    func _navigationBeginPopInitiallyInteractive(initiallyInteractive:Bool)
    func _navigationBeginPush()
    func _navigationTransitionWillPop()
    func _navigationTransitionDidPop()
    func _navigationTransitionWillPush()
    func _navigationTransitionDidPush()
}


public class BKNavigationBar: UINavigationBar {
    
    /// 设置导航栏背景色
    public var color:UIColor?{
        didSet{
            if color == nil {
                color = .white
            }
            setNavigationBarWithColor(color: color!)
        }
    }
    
    /// 设置导航栏标题颜色
    public var titleColor:UIColor?{
        didSet{
            self.titleTextAttributes?[NSAttributedString.Key.foregroundColor]=titleColor
        }
    }
    
    /// 设置导航栏背景图
    public var backgroundImage:UIImage?{
        didSet{
            setBackgroundImage(backgroundImage, for: .default)
        }
    }
    
    /// 设置导航栏字体
    public var titleFont:UIFont?{
        didSet{
            self.titleTextAttributes?[NSAttributedString.Key.font]=titleFont
        }
    }
    @objc public var backItemImage:UIImage?
    
    /// 设置导航栏渐变背景色
    public var gradientColors:[UIColor]?{
        didSet{
            if gradientColors != nil {
                _gradientImage =  imageWithGradients(colors: gradientColors!)
            }
            backgroundImage = _gradientImage
        }
    }
    //MARK: - Private
    private lazy var _whiteImage: UIImage = {
         let img = imageWithColor(color: UIColor.white)
        return img
    }()
    private lazy var _clearImage: UIImage = {
         let img = imageWithColor(color: UIColor.clear)
        return img
    }()
    private lazy var _backgroundImageView:UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    private lazy var _rigntBackgroundImageView:UIImageView = {
        let imgv = UIImageView()
        imgv.accessibilityLabel = "右边过渡假导航"
        imgv.isHidden = true
        return imgv
    }()
    private lazy var _leftBackgroundImageView:UIImageView = {
        let imgv = UIImageView()
        imgv.accessibilityLabel = "左边过渡假导航"
        imgv.isHidden = true
        return imgv
    }()
    private var _gradientImage:UIImage?
    private var _bgFrame:CGRect = .zero
    private var _popInBarItem:Bool = false
    private var _trailingItemStackView:UIStackView?
    private var _leadingItemStackView:UIStackView?
    internal weak var navigationController:UINavigationController?
    
    public override class func appearance() -> Self {
        return bar as! Self
    }
    public override init(frame: CGRect) {
        super.init(frame:frame)
        isTranslucent = false
        insertSubview(_rigntBackgroundImageView, at: 0)
        insertSubview(_leftBackgroundImageView, at: 0)
    }
    public override func awakeFromNib() {
        super.awakeFromNib()
        isTranslucent = false
        insertSubview(_rigntBackgroundImageView, at: 0)
        insertSubview(_leftBackgroundImageView, at: 0)
    }
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    private func swiftClassFromString(className: String) -> AnyClass? {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // YourProject.className
            let classStringName = appName + "." + className
            return NSClassFromString(classStringName)
        }
        return nil;
    }
    private func setNavigationBarWithColor(color:UIColor) -> Void {
        var image:UIImage?
        if color == UIColor.clear {
            image = _clearImage
        }else if color == UIColor.white{
            image = _whiteImage
        }else{
            image = imageWithColor(color: color)
        }
        backgroundImage=image
        setBackgroundImage(backgroundImage, for: .default)
    }
    private func _configBarButtonStackView(stackView:UIStackView){
        let buttonBar:NSObject = stackView.value(forKey: "buttonBar") as! NSObject
        let itemGroups:[UIBarButtonItemGroup] = buttonBar.value(forKey: "barButtonGroups") as! [UIBarButtonItemGroup]
        var buttons:[UIControl] = stackView.arrangedSubviews as! [UIControl]

        var i = 0
        buttons.forEach { (btn) in
            if btn.isMember(of: UIView.self) {
                buttons.remove(at: i)
            }
            i += 1
        }
        var k = 0
        if itemGroups.first?.barButtonItems.count == buttons.count {
            buttons.forEach { (btn) in
                let item:UIBarButtonItem? = itemGroups.first?.barButtonItems[k]
                item?.barButton = btn
            }
            k += 1
        }

    }
    ///处理透明区域响应事件，传递至下一层
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = super.hitTest(point, with: event)
        let acls: AnyClass? = NSClassFromString("_UINavigationBarContentView")//swiftClassFromString(className: "_UINavigationBarContentView")
        if acls == nil {
            return v
        }
        let isacls = (v?.isMember(of: acls!) == true) || (v?.isMember(of: BKNavigationBar.self) == true)
        if (v != nil && self.color != nil && isacls == true) {
            var alpha:CGFloat = 0.0;
            self.color?.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            if (alpha<0.01) {
                let aPoint = self.convert(point, to: self.navigationController?.topViewController?.view)
                let v1 = self.navigationController?.topViewController?.view.hitTest(aPoint, with: event)
                return v1;
            }
        }
        return v
    }
    public  override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { (subView1) in
            if #available(iOS 10.0, *){
                let cls1: AnyClass? = NSClassFromString("_UIBarBackground")//swiftClassFromString(className: "_UIBarBackground")
                let cls2: AnyClass? = NSClassFromString("_UINavigationBarContentView")//swiftClassFromString(className: "_UINavigationBarContentView")

                if cls1 != nil && subView1.isMember(of: cls1!){
                    _bgFrame = subView1.frame
                    subView1.subviews.forEach { (subView2) in
                        if subView2.isKind(of: UIImageView.self) && subView2.frame.height>0 && subView2.frame.height < 1.0 {
                            subView2.isHidden=true;
                        }else if subView2.isKind(of: UIVisualEffectView.self){
                            subView2.isHidden=true;
                        }else if subView2.isKind(of: UIImageView.self){
                            _backgroundImageView = subView2 as! UIImageView;
                        }
                    }
                    
                }else if cls2 != nil && subView1.isMember(of: cls2!){
                    let cls3: AnyClass? = NSClassFromString("_UIButtonBarStackView")//swiftClassFromString(className: "_UIButtonBarStackView")
                    subView1.subviews.forEach { (subView2) in
                        if cls3 != nil && subView2.isMember(of: cls3!){
                            self._configBarButtonStackView(stackView: subView2 as! UIStackView)
                        }
                    }
                }
                
            }else{
                let cls4: AnyClass? = NSClassFromString("_UINavigationBarBackground")//swiftClassFromString(className: "_UINavigationBarBackground")
                if cls4 != nil && subView1.isMember(of: cls4!) {
                    subView1.subviews.forEach { (subView2) in
                        if subView2.isKind(of: UIImageView.self) && subView2.frame.height>0 && subView2.frame.height < 1.0 {
                            subView2.isHidden=true
                        }
                    }
                }
            }
        }
        self.sendSubviewToBack(_rigntBackgroundImageView)
        self.sendSubviewToBack(_leftBackgroundImageView)
    }
}





//MARK: - 颜色->图片
extension BKNavigationBar{
    private func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    private func imageWithGradients(colors:[UIColor]) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext();
        if context == nil {
            return nil
        }
        let beginColor = colors.first!;
        let endColor = colors.last!;
        drawLinearGradient(context: context!, rect: rect, startColor: beginColor.cgColor, endColor: endColor.cgColor);
        context!.restoreGState();
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    private func drawLinearGradient(context:CGContext,  rect:CGRect,  startColor:CGColor,  endColor:CGColor){
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let locations:[CGFloat] = [ 0.0, 1.0 ];
        let colors = [startColor,endColor];
         let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let startPoint = CGPoint(x:0,y:0);
        let endPoint = CGPoint(x:1,y:0);
        context.saveGState();
        context.addRect(rect);
        context.clip();
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.setStrokeColor(UIColor.clear.cgColor);
    }
}

extension BKNavigationBar : _BarPrivateProtocol{
    
    func _updateTransitionPercent(percent: CGFloat) {
        let leftW=self.frame.width * percent;
        let rightW=self.frame.width - leftW;
        _leftBackgroundImageView.frame=CGRect(x:0, y:_bgFrame.origin.y, width:leftW, height:_bgFrame.size.height);
        _rigntBackgroundImageView.frame=CGRect(x:leftW, y:_bgFrame.origin.y, width:rightW, height:_bgFrame.size.height);
    }
    
    func _updateTransitionLeftImage(image: UIImage) {
        _leftBackgroundImageView.backgroundColor=nil;
        _leftBackgroundImageView.image=image;
    }
    
    func _updateTransitionLeftColor(color: UIColor?) {
        var acl = color
        if (acl == nil) {
            acl = .clear;
        }
        _leftBackgroundImageView.backgroundColor=acl;
        _leftBackgroundImageView.image=nil;

    }
    
    func _updateTransitionLeftGradientColors(gradientColors: [UIColor]) {
        _leftBackgroundImageView.image=self.imageWithGradients(colors: gradientColors);
        _leftBackgroundImageView.backgroundColor=nil;
    }
    
    func _updateTransitionRightImage(image: UIImage) {
        _rigntBackgroundImageView.backgroundColor=nil;
        _rigntBackgroundImageView.image=image;
    }
    
    func _updateTransitionRightColor(color: UIColor?) {
        var acl = color
        if (acl == nil) {
            acl = .clear;
        }
        _rigntBackgroundImageView.backgroundColor=acl;
        _rigntBackgroundImageView.image=nil;
    }
    
    func _updateTransitionRightGradientColors(gradientColors: [UIColor]) {
            _rigntBackgroundImageView.image=self.imageWithGradients(colors: gradientColors);
        _rigntBackgroundImageView.backgroundColor=nil;
    }
    
    func _navigationBeginPopInitiallyInteractive(initiallyInteractive: Bool) {
        if (initiallyInteractive == false) {
            _popInBarItem=true;
        }
    }
    
    func _navigationBeginPush() {
        
    }
    
    func _navigationTransitionWillPop() {
        _rigntBackgroundImageView.isHidden = false
        _leftBackgroundImageView.isHidden = false
        _leftBackgroundImageView.frame=CGRect(x:0, y:_bgFrame.origin.y, width:0, height:_bgFrame.size.height);
        _rigntBackgroundImageView.frame=CGRect(x:0, y:_bgFrame.origin.y, width:self.frame.width, height:_bgFrame.size.height);
        self.insertSubview(_rigntBackgroundImageView, at: 0)
        self.insertSubview(_leftBackgroundImageView, at: 0)
        _backgroundImageView.alpha=0;
        if (_popInBarItem == true) {
            _popInBarItem=false;
            UIView.beginAnimations("firstAnimation", context: nil)
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: 7)!)
            UIView.setAnimationDuration(0.35)
            self._updateTransitionPercent(percent: 1)
            UIView.commitAnimations()
        }

    }
    
    func _navigationTransitionDidPop() {
        _backgroundImageView.alpha=1;
        _rigntBackgroundImageView.isHidden=true
        _leftBackgroundImageView.isHidden=true;
        _rigntBackgroundImageView.removeFromSuperview();
        _leftBackgroundImageView.removeFromSuperview();
    }
    
    func _navigationTransitionWillPush() {
            _rigntBackgroundImageView.isHidden = false
            _leftBackgroundImageView.isHidden = false
        _leftBackgroundImageView.frame=CGRect(x:0, y:_bgFrame.origin.y, width:self.frame.width, height:_bgFrame.size.height);
        _rigntBackgroundImageView.frame=CGRect(x:self.frame.width, y:_bgFrame.origin.y, width:0, height:_bgFrame.size.height);
        self.insertSubview(_rigntBackgroundImageView, at: 0)
        self.insertSubview(_leftBackgroundImageView, at: 0)
        _backgroundImageView.alpha=0;
        UIView.beginAnimations("firstAnimation", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: 7)!)
        UIView.setAnimationDuration(0.35)
        self._updateTransitionPercent(percent: 0)
        UIView.commitAnimations()
    }
    
    func _navigationTransitionDidPush() {
        _backgroundImageView.alpha=1;
        _rigntBackgroundImageView.isHidden=true
        _leftBackgroundImageView.isHidden=true;
        _rigntBackgroundImageView.removeFromSuperview();
        _leftBackgroundImageView.removeFromSuperview();
    }
    
    
    
}
