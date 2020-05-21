//
//  BKPopoverViewController.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/18.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
class BKPopoverItem{
    var title:String?
    var image:UIImage?
    var tag:Int?
    var actionHandle:((_ item:BKPopoverItem)->Void)?
    init(title:String?,image:UIImage?) {
        self.title=title
        self.image=image
    }
}
class BKPopoverViewController: UIViewController {
    enum Direction {
        enum Arrow {
            case auto,left,right,top,bottom,center
        }
        case vertical(arrow:Arrow)//auto,left,right,center
        case horizontal(arrow:Arrow)//auto,top,bottom,center
    }
    enum ArrowStyle {
        case isosceles(size:CGSize) //等腰
        case oblique(size:CGSize) //斜角
        
        var size:CGSize{
            switch self {
            case .isosceles(let size):
                return size
            case .oblique(let size):
                return size
            }
        }
    }
    enum Style {
        case auto(rowHeight:CGFloat,minWidth:CGFloat) // 固定行高 宽度高度自适应（大于最小宽度）
        case size(size:CGSize) // 宽高固定大小
    }
    var items:[BKPopoverItem] = []{
        didSet{
            updateContentSize()
        }
    }
    var direction:Direction = .vertical(arrow: .auto)
    var tableView:UITableView = UITableView()
    var backgroundColor:UIColor = .white
    var titleColor:UIColor = .darkText
    var orientation:UIInterfaceOrientation = .portrait
    var selectedColor:UIColor = UIColor(white: 230.0/255.0, alpha: 1)
    var style:Style = .auto(rowHeight: 44.0, minWidth: 100.0)
    var arrowStyle:ArrowStyle = .isosceles(size: CGSize(width: 24, height: 15))
    private var backgroundView = _BKPopoverBackgroundView()
    private var transition:BKTransition = BKTransition()
    private var popoverSize:CGSize = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundView.controller=self
    }
    func show(inController:UIViewController,target:UIView) {
        let frameInWindow = target.screenFrame
        show(inController: inController, rect: frameInWindow)
    }
    func show(inController:UIViewController,point:CGPoint) {
        show(inController: inController, rect: CGRect(x: point.x, y: point.y, width: 0, height: 0))
    }
    func show(inController:UIViewController,rect:CGRect) {
        updateContentRect(target: rect)
        self.transitioningDelegate = self.transition;
        self.modalPresentationStyle = .custom;
        inController.present(self, animated: true, completion: nil)
    }
    func updateContentRect(target:CGRect) {
        var rect = CGRect(x: 0, y: 0, width: popoverSize.width, height: popoverSize.height)
        switch self.direction {
        case .vertical(_):
            if target.maxY+popoverSize.height < SCREEN.HEIGHT {
                rect.origin.y = target.maxY
            }else if target.minY - popoverSize.height > 0 {
                rect.origin.y = target.minY - popoverSize.height
            }else{
                rect.origin.y = target.maxY
                rect.size.height = SCREEN.HEIGHT-target.maxY
            }
        case .horizontal(_):
            if target.maxX+popoverSize.width < SCREEN.WIDTH {
                rect.origin.x = target.maxX
            }else if target.minX - popoverSize.width > 0 {
                rect.origin.x = target.minX - popoverSize.width
            }else{
                rect.origin.x = target.maxX
                rect.size.width = SCREEN.WIDTH - target.maxX
            }
        }
    }
    func updateContentSize() {
        var maxTextWidth:CGFloat = 0
        var height:CGFloat = 0;
        items.forEach { (item) in
            var wd:CGFloat = 0
            if let text = (item.title as NSString?) {
                wd = text.size(withAttributes: [.font:UIFont.systemFont(ofSize: 15)]).width+10
            }
            if item.image != nil {
                wd += 10
                wd += item.image!.size.width
            }
            maxTextWidth = max(wd, maxTextWidth)
        }
        if (maxTextWidth<100) {
            maxTextWidth=100;
        }else if (maxTextWidth>(UIScreen.main.bounds.width/2)){
            maxTextWidth=(UIScreen.main.bounds.width/2);
        }
        maxTextWidth += 10
        switch self.style {
        case .auto(let rowHeight, let minWidth):
         height = rowHeight * CGFloat(self.items.count)+self.arrowStyle.size.height;
         if maxTextWidth<minWidth {
            maxTextWidth=minWidth
         }
        case .size(let size):
            height = size.height
            maxTextWidth = size.width
        }
        popoverSize = CGSize(width: maxTextWidth, height: height)
    }
}
class _BKPopoverBackgroundView: UIView {
    weak var controller:BKPopoverViewController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        guard self.controller != nil else {
            return
        }
        switch controller!.arrowStyle {
        case .isosceles(let size):
             _drawIsosceles(context: context,arrowSize: size)
        case .oblique(let size):
            _drawOblique(context: context,arrowSize: size)
        }
//        //左下
//        context.move(to: CGPoint(x: maskFrame.minX-cor, y: maskFrame.maxY))
//        context.addQuadCurve(to: CGPoint(x: maskFrame.minX, y: maskFrame.midY), control: CGPoint(x: maskFrame.minX-cap*0.8, y: maskFrame.maxY-cap*0.8))
//        context.addLine(to: CGPoint(x: maskFrame.minX, y: maskFrame.midY))
//        //左上
//        context.addQuadCurve(to: CGPoint(x: maskFrame.minX+cor, y: maskFrame.minY), control: CGPoint(x: maskFrame.minX+cap*0.8, y: maskFrame.minY+cap*0.8))
//        context.addLine(to: CGPoint(x: maskFrame.maxX-cor, y: maskFrame.minY))
//        //右上
//        context.addQuadCurve(to: CGPoint(x: maskFrame.maxX, y: maskFrame.midY), control: CGPoint(x: maskFrame.maxX-cap*0.8, y: maskFrame.minY+cap*0.8))
//        context.addLine(to: CGPoint(x: maskFrame.maxX, y: maskFrame.midY))
//        //右下
//        context.addQuadCurve(to: CGPoint(x: maskFrame.maxX+cor, y: maskFrame.maxY), control: CGPoint(x: maskFrame.maxX+cap*0.8, y: maskFrame.maxY-cap*0.8))
//
//        context.addLine(to: CGPoint(x: maxwidth, y: maskFrame.maxY))
//        context.addLine(to: CGPoint(x: maxwidth, y: 0))
//        context.addLine(to: CGPoint(x: 0, y: 0))
//        context.addLine(to: CGPoint(x: 0, y: maskFrame.maxY))
//        context.addLine(to: CGPoint(x: maskFrame.minX-cor, y: maskFrame.maxY))
        
        
        context.setFillColor(controller!.backgroundColor.cgColor)
        context.fillPath()

    }
    func _drawIsosceles(context:CGContext, arrowSize:CGSize) {
        switch controller!.direction {
        case .horizontal(let arrow):
            _drawIsoscelesHor(arrow: arrow)
        case .vertical(let arrow):
            _drawIsoscelesVer(arrow: arrow)
        }
    }
    func _drawIsoscelesHor(arrow:BKPopoverViewController.Direction.Arrow) {
        
    }
    func _drawIsoscelesVer(arrow:BKPopoverViewController.Direction.Arrow) {
        
    }
    
    func _drawOblique(context:CGContext, arrowSize:CGSize) {
        switch controller!.direction {
        case .horizontal(let arrow):
            _drawObliqueHor(arrow: arrow)
        case .vertical(let arrow):
            _drawObliqueVer(arrow: arrow)
        }
    }
    func _drawObliqueHor(arrow:BKPopoverViewController.Direction.Arrow) {
        
    }
    func _drawObliqueVer(arrow:BKPopoverViewController.Direction.Arrow) {
        
    }
}
