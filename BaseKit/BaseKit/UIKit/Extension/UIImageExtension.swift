//
//  UIImageExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/9.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
extension UIImage{
    
    /// 根据颜色生成图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 图片
    public class func image(withColor color:UIColor, size:CGSize? = CGSize(width: 1, height: 1)) -> UIImage?{
        let rect = CGRect(origin: .zero, size: size!)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 修改图片元素颜色
    /// - Parameter imageTintColor: 颜色
    /// - Returns: 修改完后的图片
    public func image(imageTintColor:UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        imageTintColor.setFill()
        let rect = CGRect(origin: .zero, size: self.size)
        UIRectFill(rect)
        self.draw(in: rect, blendMode: .destinationIn, alpha: 1)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 给图片填充背景色
    /// - Parameters:
    ///   - backgroundColor: 颜色
    ///   - size: 画布大小
    /// - Returns: 生成新的图片
    public func image(backgroundColor:UIColor,size:CGSize?) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size ?? self.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(rect)
        let selfSize = self.size
        self.draw(in: CGRect(x: rect.size.width/2-selfSize.width/2, y: rect.size.height/2-selfSize.height/2, width: selfSize.width, height: selfSize.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 生成Gif图片
    /// - Parameter GIFData: gif data
    /// - Returns: gif图片
    public class func image(GIFData:Data) -> UIImage?{
        guard let source = CGImageSourceCreateWithData(GIFData as CFData, nil) else { return nil }
        let count = CGImageSourceGetCount(source)
        var animatedImage:UIImage?
        if count <= 1 {
            animatedImage = UIImage.init(data: GIFData)
        }else{
            var images:[UIImage] = []
            var duration:Float = 0.0
            for i in 0..<count {
                guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else { return nil }
                duration += _frameDuration(atIndex: i, source: source)
                images.append(UIImage(cgImage: image, scale: 1.5, orientation: .up))
            }
            if (duration != 0.0) {
                duration = (1.0 / 10.0) * Float(count);
            }
            animatedImage = UIImage.animatedImage(with: images, duration: TimeInterval(duration))
        }
        return animatedImage
    }
    private class func _frameDuration(atIndex:Int, source:CGImageSource) -> Float{
        var frameDuration:Float = 0.1
        let frameProperties:NSDictionary = CGImageSourceCopyPropertiesAtIndex(source, atIndex, nil) ?? NSDictionary()
        let gifProperties:NSDictionary = frameProperties[kCGImagePropertyGIFDictionary as NSString] as! NSDictionary
        let delayTimeUnclampedProp = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as NSString] as? NSNumber
        if  delayTimeUnclampedProp != nil {
            frameDuration = delayTimeUnclampedProp!.floatValue
        }else{
            let delayTimeProp = gifProperties[kCGImagePropertyGIFDelayTime as NSString] as? NSNumber
            if delayTimeProp != nil {
                frameDuration = delayTimeUnclampedProp!.floatValue
            }
        }
        if (frameDuration < 0.011) {
            frameDuration = 0.100;
        }
        return frameDuration;
    }
}
