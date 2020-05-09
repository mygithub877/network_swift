//
//  UIImageExtension.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/9.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
extension UIImage{
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
    func image(imageTintColor:UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        imageTintColor.setFill()
        let rect = CGRect(origin: .zero, size: self.size)
        UIRectFill(rect)
        self.draw(in: rect, blendMode: .destinationIn, alpha: 1)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    func image(backgroundColor:UIColor,size:CGSize?) -> UIImage? {
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
//    public class func image(GIFData:Data) -> UIImage?{
//        guard let source = CGImageSourceCreateWithData(GIFData as CFData, nil) else { return nil }
//        let count = CGImageSourceGetCount(source)
//        var animatedImage:UIImage?
//        if count <= 1 {
//            animatedImage = UIImage.init(data: GIFData)
//        }else{
//            var images:[UIImage] = []
//            var duration = 0.0
//            for i in 0..<count {
//                let image = CGImageSourceCreateImageAtIndex(source, i, nil)
//                
//            }
//        }
//
//    }
}
