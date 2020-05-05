//
//  BKNavigationBar.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
fileprivate let bar = BKNavigationBar()
protocol _BarPrivateProtocol : NSObject{
    var navigationController:UINavigationController? { get set }
    func _updateTransitionPercent(percent:CGFloat)
    func _updateTransitionLeftImage(image:UIImage)
    func _updateTransitionLeftColor(color:UIColor)
    func _updateTransitionLeftGradientColors(gradientColors:[UIColor])
    func _updateTransitionRightImage(image:UIImage)
    func _updateTransitionRightColor(color:UIColor)
    func _updateTransitionRightGradientColors(gradientColors:[UIColor])
    func _navigationBeginPopInitiallyInteractive(initiallyInteractive:Bool)
    func _navigationBeginPush()
    func _navigationTransitionWillPop()
    func _navigationTransitionDidPop()
    func _navigationTransitionWillPush()
    func _navigationTransitionDidPush()
}


public class BKNavigationBar: UINavigationBar {
    public var color:UIColor?{
        didSet{
            if color == nil {
                color = .white
            }
            setNavigationBarWithColor(color: color!)
        }
    }
    public var titleColor:UIColor?{
        didSet{
            self.titleTextAttributes?[NSAttributedString.Key.foregroundColor]=titleColor
        }
    }
    public var backgroundImage:UIImage?{
        didSet{
            setBackgroundImage(backgroundImage, for: .default)
        }
    }
    public var titleFont:UIFont?{
        didSet{
            self.titleTextAttributes?[NSAttributedString.Key.font]=titleFont
        }
    }
    public var backItemImage:UIImage?
    public var gradientColors:[UIColor]?{
        didSet{
            if gradientColors != nil {
                _gradientImage =  imageWithGradients(colors: gradientColors!)
            }
            backgroundImage = _gradientImage
        }
    }
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
    private var _bgFrame:CGRect?
    private var _popInBarItem:Bool?
    private var _trailingItemStackView:UIStackView?
    private var _leadingItemStackView:UIStackView?

    public override class func appearance() -> Self {
        return bar as! Self
    }
    public override init(frame: CGRect) {
        super.init(frame:frame)
        isTranslucent = true
        insertSubview(_rigntBackgroundImageView, at: 0)
        insertSubview(_leftBackgroundImageView, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
