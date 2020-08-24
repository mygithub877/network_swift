//
//  UIColorExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/9.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
private var colorsCache:NSCache = NSCache<AnyObject, UIColor>()
extension UIColor{
    
    /// 依据16进制颜色字符创建一个UIColor
    /// - Parameters:
    ///   - hex: 16进制颜色 000000~FFFFFF
    ///   - alpha: 透明度 0~1
    /// - Returns: 颜色对象
    
    public class func hex(_ hex:String, alpha:CGFloat? = 1.0)->UIColor {
        let colorhex = hex.replacingOccurrences(of: "#", with: "")
        if alpha == 1.0{
            if let color = colorsCache.object(forKey: hex as AnyObject){
                return color;
            }
        }
        let scanner:Scanner = Scanner(string: colorhex)
        var rgbValue:UInt32 = 0
        scanner.scanHexInt32(&rgbValue)
        let redColor:CGFloat = CGFloat(rgbValue >> 16)
        let greenColor:CGFloat = CGFloat((rgbValue >> 8) & 0x00FF)
        let blueColor:CGFloat = CGFloat(rgbValue & 0x0000FF)
        let color = UIColor(red: redColor/255.0, green: greenColor/255.0, blue: blueColor/255.0, alpha: alpha!)
        colorsCache.setObject(color, forKey: hex as AnyObject)
        return color
    }
    
    /// 通过RGB色值生成颜色
    /// - Parameters:
    ///   - red: 红色值 0~255
    ///   - green: 绿色值 0~255
    ///   - blue: 蓝色值 0~255
    ///   - alpha: 透明度 0~1
    /// - Returns: 颜色对象
    public class func RGB(r red:UInt8,g green:UInt8,b blue:UInt8,alpha:CGFloat? = 1.0)->UIColor{
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha!)
        return color
    }
}
