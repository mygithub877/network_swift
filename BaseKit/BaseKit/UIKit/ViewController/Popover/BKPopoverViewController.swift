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
    fileprivate var backgroundView = _BKPopoverBackgroundView()
    fileprivate var transition:BKTransition = BKTransition()
    fileprivate var popoverSize:CGSize = .zero
    fileprivate var targetRect:CGRect = .zero
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
        self.targetRect = rect
        self.transitioningDelegate = self.transition;
        self.modalPresentationStyle = .custom;
        inController.present(self, animated: true, completion: nil)
    }
    func updateContentRect(target:CGRect) {
        var rect = CGRect(x: 0, y: 0, width: popoverSize.width, height: popoverSize.height)
        switch self.direction {
        case .vertical(let arrow):
            if target.maxY+popoverSize.height < SCREEN.HEIGHT {
                rect.origin.y = target.maxY
            }else if target.minY - popoverSize.height > 0 {
                rect.origin.y = target.minY - popoverSize.height
            }else{
                rect.origin.y = target.maxY
                rect.size.height = SCREEN.HEIGHT-target.maxY
            }
            rect.origin.x = updateVerticalX(arrow: arrow, target: target)
        case .horizontal(let arrow):
            if target.maxX+popoverSize.width < SCREEN.WIDTH {
                rect.origin.x = target.maxX
            }else if target.minX - popoverSize.width > 0 {
                rect.origin.x = target.minX - popoverSize.width
            }else{
                rect.origin.x = target.maxX
                rect.size.width = SCREEN.WIDTH - target.maxX
            }
            rect.origin.y = updateHorizontalY(arrow: arrow, target: target)
        }
        transition.presentRect = rect
    }
    func updateVerticalX(arrow:BKPopoverViewController.Direction.Arrow,target:CGRect) -> CGFloat {
        switch arrow {
        case .left:
            //
            return target.midX-popoverSize.width*1/4.0
        case .right:
            //
            return target.midX-popoverSize.width*3/4.0
        case .center:
            return target.midX-popoverSize.width/2
        default:
            if target.midX-popoverSize.width/2 < 10 {
                return updateVerticalX(arrow: .left, target: target)
            }else if target.midX+popoverSize.width/2 > SCREEN.WIDTH-10{
                return updateVerticalX(arrow: .right, target: target)
            }else{
                return updateVerticalX(arrow: .center, target: target)
            }
        }
    }
    func updateHorizontalY(arrow:BKPopoverViewController.Direction.Arrow,target:CGRect) -> CGFloat {
        switch arrow {
        case .top:
            //
            return target.midY-popoverSize.height*1/4.0
        case .bottom:
            //
            return target.midY-popoverSize.height*3/4.0
        case .center:
            return target.midY-popoverSize.height/2
        default:
            if target.midY-popoverSize.height/2 < 10 {
                return updateHorizontalY(arrow: .top, target: target)
            }else if target.midY+popoverSize.height/2 > SCREEN.HEIGHT-10{
                return updateHorizontalY(arrow: .bottom, target: target)
            }else{
                return updateHorizontalY(arrow: .center, target: target)
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
    var arrowRadius:CGFloat = 2
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
        context.setFillColor(controller!.backgroundColor.cgColor)
        context.fillPath()

    }
    /// 等腰直角
    func _drawIsosceles(context:CGContext, arrowSize:CGSize) {
        switch controller!.direction {
        case .horizontal(_):
            _drawIsoscelesHor(context: context,arrowSize: arrowSize)
        case .vertical(_):
            _drawIsoscelesVer(context: context,arrowSize: arrowSize)
        }
    }
    func _drawIsoscelesHor(context:CGContext,arrowSize:CGSize) {
        let cornerRadius = self.layer.cornerRadius
        if controller!.targetRect.minX > controller!.transition.presentRect.maxX {//右
            let arrowRect = CGRect(x: self.bounds.maxX-arrowSize.height, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.midY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.midY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.midY))
            //三角上边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius , y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX, y: arrowRect.minY-arrowRadius), control: CGPoint(x: arrowRect.minY, y: arrowRect.minX))
            //边框右上角
            context.addLine(to: CGPoint(x: arrowRect.minX, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-cornerRadius, y:0 ), control: CGPoint(x: arrowRect.minY, y:0 ))
            //边框左上角
            context.addLine(to: CGPoint(x: cornerRadius, y: 0))
            context.addQuadCurve(to: CGPoint(x: 0, y: cornerRadius), control: CGPoint(x: 0, y: 0))
            //边框左下角
            context.addLine(to: CGPoint(x: 0, y: self.bounds.maxY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: cornerRadius, y: self.bounds.maxY), control: CGPoint(x: 0, y: self.bounds.maxY))
            //边框右下角
            context.addLine(to: CGPoint(x: arrowRect.minX-cornerRadius , y: self.bounds.maxY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX, y:self.bounds.maxY-cornerRadius), control: CGPoint(x:arrowRect.minX , y: self.bounds.maxY))
            //三角下边角
            context.addLine(to: CGPoint(x: arrowRect.minX, y: arrowRect.maxY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.minX, y: arrowRect.maxY))
            //最后连起来
            context.addLine(to: start)

        }else{//左
            let arrowRect = CGRect(x: 0, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.midY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.midY-arrowRadius), control: CGPoint(x: arrowRect.minX, y: arrowRect.midY))
            //三角上边角
            context.addLine(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX, y: arrowRect.minY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.minY))
            //边框左上角
            context.addLine(to: CGPoint(x: arrowRect.maxX, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX+cornerRadius, y: 0), control: CGPoint(x: arrowRect.maxX, y: 0))
            //边框右上角
            context.addLine(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: 0))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: cornerRadius), control: CGPoint(x: self.bounds.maxX, y: 0))
            //边框右下角
            context.addLine(to: CGPoint(x: self.bounds.maxX , y: self.bounds.maxY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius , y:self.bounds.maxY ), control: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
            //边框左下角
            context.addLine(to: CGPoint(x: arrowRect.maxX+cornerRadius , y:self.bounds.maxY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX, y: self.bounds.maxY-cornerRadius), control: CGPoint(x: arrowRect.maxX , y: self.bounds.maxY))
            //三角下边角
            context.addLine(to: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY))
            //最后连起来
            context.addLine(to: start)

        }
    }
    func _drawIsoscelesVer(context:CGContext,arrowSize:CGSize) {
        let cornerRadius = self.layer.cornerRadius
        if controller!.targetRect.minY > controller!.transition.presentRect.maxY {//上
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2, y: self.bounds.maxY-arrowSize.height, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.midX+arrowRadius, y: arrowRect.maxY-arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.midX-arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.midX, y: arrowRect.maxY))
            //三角左边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-arrowRadius, y: arrowRect.minY), control: CGPoint(x: arrowRect.minX, y: arrowRect.minY))
            //边框左下角
            context.addLine(to: CGPoint(x: cornerRadius, y: arrowRect.minY))
            context.addQuadCurve(to: CGPoint(x: 0, y: arrowRect.minY-cornerRadius), control: CGPoint(x: 0, y: arrowRect.minY))
            //边框左上角
            context.addLine(to: CGPoint(x: 0, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), control: CGPoint(x: 0, y: 0))
            //边框右上角
            context.addLine(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: 0))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: cornerRadius), control: CGPoint(x: self.bounds.maxX, y: 0))
            //边框右下角
            context.addLine(to: CGPoint(x: self.bounds.maxX, y: arrowRect.minY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: arrowRect.minY), control: CGPoint(x: self.bounds.maxX, y: arrowRect.minY))
            //三角右边角
            context.addLine(to: CGPoint(x: arrowRect.maxX+arrowRadius, y: arrowRect.minY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.minY+arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.minY))
            //最后连起来
            context.addLine(to: start)

        }else{//下
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2, y: 0, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.midX+arrowRadius, y: arrowRect.minY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.midX-arrowRadius, y: arrowRect.minY+arrowRadius), control: CGPoint(x: arrowRect.midX, y: arrowRect.minY))
            //三角左边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.maxY-arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-arrowRadius, y: arrowRect.maxY), control: CGPoint(x: arrowRect.minX, y: arrowRect.maxY))
            //边框左上角
            context.addLine(to: CGPoint(x: cornerRadius, y: arrowRect.maxY))
            context.addQuadCurve(to: CGPoint(x: 0, y: arrowRect.maxY+cornerRadius), control: CGPoint(x: 0, y: arrowRect.maxY))
            //边框左下角
            context.addLine(to: CGPoint(x: 0, y: self.bounds.maxY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: cornerRadius, y: self.bounds.maxY), control: CGPoint(x: 0, y: self.bounds.maxY))
            //边框右下角
            context.addLine(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: self.bounds.maxY))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY-cornerRadius), control: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
            //边框右上角
            context.addLine(to: CGPoint(x: self.bounds.maxX, y: arrowRect.maxY+cornerRadius))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: self.bounds.maxY), control: CGPoint(x: self.bounds.maxX, y: arrowRect.maxY))
            //三角右边角
            context.addLine(to: CGPoint(x: arrowRect.maxX+arrowRadius, y: arrowRect.maxY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY))
            //最后连起来
            context.addLine(to: start)
        }
    }
    //斜角
    func _drawOblique(context:CGContext, arrowSize:CGSize) {
        switch controller!.direction {
        case .horizontal(let arrow):
            _drawObliqueHor(arrow: arrow,context: context,arrowSize: arrowSize)
        case .vertical(let arrow):
            _drawObliqueVer(arrow: arrow,context: context,arrowSize: arrowSize)
        }
    }
    func _drawObliqueHor(arrow:BKPopoverViewController.Direction.Arrow,context:CGContext,arrowSize:CGSize) {
        let cornerRadius = self.layer.cornerRadius
        if controller!.targetRect.minX > controller!.transition.presentRect.maxX {//右
            let arrowRect = CGRect(x: self.bounds.maxX-arrowSize.height, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.midY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.midY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.midY))
            //三角上边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius , y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX, y: arrowRect.minY-arrowRadius), control: CGPoint(x: arrowRect.minY, y: arrowRect.minX))
            //边框右上角
            context.addLine(to: CGPoint(x: arrowRect.minX, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-cornerRadius, y:0 ), control: CGPoint(x: arrowRect.minY, y:0 ))
            //边框左上角
            context.addLine(to: CGPoint(x: cornerRadius, y: 0))
            context.addQuadCurve(to: CGPoint(x: 0, y: cornerRadius), control: CGPoint(x: 0, y: 0))
            //边框左下角
            context.addLine(to: CGPoint(x: 0, y: self.bounds.maxY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: cornerRadius, y: self.bounds.maxY), control: CGPoint(x: 0, y: self.bounds.maxY))
            //边框右下角
            context.addLine(to: CGPoint(x: arrowRect.minX-cornerRadius , y: self.bounds.maxY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX, y:self.bounds.maxY-cornerRadius), control: CGPoint(x:arrowRect.minX , y: self.bounds.maxY))
            //三角下边角
            context.addLine(to: CGPoint(x: arrowRect.minX, y: arrowRect.maxY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.minX, y: arrowRect.maxY))
            //最后连起来
            context.addLine(to: start)

        }else{//左
            let arrowRect = CGRect(x: 0, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.midY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.midY-arrowRadius), control: CGPoint(x: arrowRect.minX, y: arrowRect.midY))
            //三角上边角
            context.addLine(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX, y: arrowRect.minY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.minY))
            //边框左上角
            context.addLine(to: CGPoint(x: arrowRect.maxX, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX+cornerRadius, y: 0), control: CGPoint(x: arrowRect.maxX, y: 0))
            //边框右上角
            context.addLine(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: 0))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: cornerRadius), control: CGPoint(x: self.bounds.maxX, y: 0))
            //边框右下角
            context.addLine(to: CGPoint(x: self.bounds.maxX , y: self.bounds.maxY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius , y:self.bounds.maxY ), control: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
            //边框左下角
            context.addLine(to: CGPoint(x: arrowRect.maxX+cornerRadius , y:self.bounds.maxY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX, y: self.bounds.maxY-cornerRadius), control: CGPoint(x: arrowRect.maxX , y: self.bounds.maxY))
            //三角下边角
            context.addLine(to: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY))
            //最后连起来
            context.addLine(to: start)

        }
    }
    func _drawObliqueVer(arrow:BKPopoverViewController.Direction.Arrow,context:CGContext,arrowSize:CGSize) {
        let cornerRadius = self.layer.cornerRadius
        if controller!.targetRect.minY > controller!.transition.presentRect.maxY {//上
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2, y: self.bounds.maxY-arrowSize.height, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.midX+arrowRadius, y: arrowRect.maxY-arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.midX-arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.midX, y: arrowRect.maxY))
            //三角左边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-arrowRadius, y: arrowRect.minY), control: CGPoint(x: arrowRect.minX, y: arrowRect.minY))
            //边框左下角
            context.addLine(to: CGPoint(x: cornerRadius, y: arrowRect.minY))
            context.addQuadCurve(to: CGPoint(x: 0, y: arrowRect.minY-cornerRadius), control: CGPoint(x: 0, y: arrowRect.minY))
            //边框左上角
            context.addLine(to: CGPoint(x: 0, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), control: CGPoint(x: 0, y: 0))
            //边框右上角
            context.addLine(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: 0))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: cornerRadius), control: CGPoint(x: self.bounds.maxX, y: 0))
            //边框右下角
            context.addLine(to: CGPoint(x: self.bounds.maxX, y: arrowRect.minY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: arrowRect.minY), control: CGPoint(x: self.bounds.maxX, y: arrowRect.minY))
            //三角右边角
            context.addLine(to: CGPoint(x: arrowRect.maxX+arrowRadius, y: arrowRect.minY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.minY+arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.minY))
            //最后连起来
            context.addLine(to: start)

        }else{//下
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2, y: 0, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.midX+arrowRadius, y: arrowRect.minY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.midX-arrowRadius, y: arrowRect.minY+arrowRadius), control: CGPoint(x: arrowRect.midX, y: arrowRect.minY))
            //三角左边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius, y: arrowRect.maxY-arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-arrowRadius, y: arrowRect.maxY), control: CGPoint(x: arrowRect.minX, y: arrowRect.maxY))
            //边框左上角
            context.addLine(to: CGPoint(x: cornerRadius, y: arrowRect.maxY))
            context.addQuadCurve(to: CGPoint(x: 0, y: arrowRect.maxY+cornerRadius), control: CGPoint(x: 0, y: arrowRect.maxY))
            //边框左下角
            context.addLine(to: CGPoint(x: 0, y: self.bounds.maxY-cornerRadius))
            context.addQuadCurve(to: CGPoint(x: cornerRadius, y: self.bounds.maxY), control: CGPoint(x: 0, y: self.bounds.maxY))
            //边框右下角
            context.addLine(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: self.bounds.maxY))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY-cornerRadius), control: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
            //边框右上角
            context.addLine(to: CGPoint(x: self.bounds.maxX, y: arrowRect.maxY+cornerRadius))
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: self.bounds.maxY), control: CGPoint(x: self.bounds.maxX, y: arrowRect.maxY))
            //三角右边角
            context.addLine(to: CGPoint(x: arrowRect.maxX+arrowRadius, y: arrowRect.maxY))
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.maxY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY))
            //最后连起来
            context.addLine(to: start)
        }
    }
}
