//
//  BKGradientView.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKGradientView: UIView {
    public  enum Style:Equatable {
        public enum Direction {
            case horizontal
            case vertical
        }
        case linear(_ direction:Direction)
        case radial
        public static func == (lhs: Self, rhs: Self) -> Bool{
            switch (lhs, rhs) {
            case (.radial,.radial):
                return true
            case (.linear(.horizontal),.linear(.horizontal)):
                return true
            case (.linear(.vertical),.linear(.vertical)):
                return true
            default:
                return false
            }
        }
    }
    public var startColor:UIColor = .clear{
        didSet{
            self.setNeedsDisplay()
        }
    }
    public var endColor:UIColor = UIColor(white: 0, alpha: 0.4){
        didSet{
            self.setNeedsDisplay()
        }
    }
    public var style:Style = .linear(.vertical){
        didSet{
            self.setNeedsDisplay()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
        // Drawing code
        if self.style == .radial {
            self._drawRadialGradientInRect(rect)
        }else{
            self._drawLinearGradientInRect(rect)
        }
    }
    //MARK: - Private Draw
    private func _drawLinearGradientInRect(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let locations:[CGFloat] = [ 0.0, 1.0 ];
        let colors = [startColor.cgColor,endColor.cgColor];
         let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        var startPoint:CGPoint
        var endPoint:CGPoint
        if self.style == .linear(.horizontal) {
            startPoint = CGPoint(x:0,y:0);
            endPoint = CGPoint(x:rect.maxX,y:0);
        }else{
            startPoint = CGPoint(x:0,y:0);
            endPoint = CGPoint(x:0,y:rect.maxY);
        }

        context?.saveGState();
        context?.addRect(rect);
        context?.clip();
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
    }
    private func _drawRadialGradientInRect(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let locations:[CGFloat] = [ 0.0, 1.0 ];
        let colors = [startColor.cgColor,endColor.cgColor];
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.minY))
        path.closeSubpath()
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else{
            return
        }
        let pathRect = path.boundingBox
        let center = CGPoint(x: pathRect.midX, y: pathRect.midY)
        let radius =  max(pathRect.width/2, pathRect.height/2)
        context?.saveGState();
        context?.addRect(rect);
        context?.clip();
        context?.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}
