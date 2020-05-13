//
//  BKDashedView.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKDashedView: UIView {
    public var lineColor:UIColor = UIColor(white: 181.0/255.0, alpha: 1){
        didSet{
            self.setNeedsDisplay()
        }
    }
    public var lineWidth:CGFloat = 5.0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    public var lineMargin:CGFloat = 5.0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    public var lineCap:CGLineCap = .butt{
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
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(self.lineColor.cgColor)
        context?.setLineWidth(self.height)
        if self.lineCap == .round || self.lineCap == .square {
            context?.move(to: CGPoint(x: self.height, y: self.height/2))
            context?.setLineDash(phase: 0, lengths: [self.lineWidth,self.lineMargin+self.height])
        }else{
            context?.move(to: CGPoint(x: 0, y: self.height/2))
            context?.setLineDash(phase: 0, lengths: [self.lineWidth,self.lineMargin])
        }
        context?.addLine(to: CGPoint(x: self.bounds.width, y: self.height/2))
        context?.setLineCap(self.lineCap)
        context?.strokePath()
    }
    
    
}
