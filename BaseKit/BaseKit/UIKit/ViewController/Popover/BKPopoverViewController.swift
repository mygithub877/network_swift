//
//  BKPopoverViewController.swift
//  BaseKit
//
//  Created by wenjie liu on 2020/5/18.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
public class BKPopoverItem{
    public var title:String?
    public var image:UIImage?
    
    /// 默认行高
    /// 如果设置为 -1 (UITableView.automaticDimension) 则自适应高度(custom情况下有效，和UITableViewCell自适应一样)
    public var cellHeight:CGFloat = 44.0  //
    /// tag
    public var tag:Int?
    
    /// 选项点击回调
    public var actionHandle:((_ item:BKPopoverItem)->Void)?
    
    ///默认标题选项颜色
    public var titleColor:UIColor = .darkText
    
    /// 默认标题选中颜色
    public var selectedColor:UIColor = UIColor(white: 230.0/255.0, alpha: 1)
    
    /// 标题字体
    public var titleFont:UIFont = UIFont.systemFont(ofSize: 14)
    
    /// 选中字体
    public var selectedTitleFont:UIFont = UIFont.systemFont(ofSize: 14)

    /// 自定义视图，如果为空则按默认样式布局
    public var custom:((_ contentView:UIView)->Void)?
    
    public init(title:String?,image:UIImage?) {
        self.title=title
        self.image=image
    }
}
public class BKPopoverViewController: UIViewController {
//MARK: - enum
    
    /// popover弹出方向
    public enum Direction {
        
        /// 箭头位置方向
        public enum Arrow {
            case auto,left,right,top,bottom,center
        }
        case vertical(arrow:Arrow)//auto,left,right,center
        case horizontal(arrow:Arrow)//auto,top,bottom,center
    }
    
    /// 箭头样式、大小
    public enum ArrowStyle {
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
    
    /// popover样式
    public enum Style {
        case auto(minWidth:CGFloat) // 宽度高度自适应（大于最小宽度）
        case size(size:CGSize) // 宽高固定大小
    }
//MARK: - var
    
    /// 需要显示的选项集合
    public var items:[BKPopoverItem] = []{
        didSet{
            updateContentSize()
        }
    }
    //箭头偏移量-> vertical: x position,horizontal:y position
    public var arrowInset:CGFloat = 0{
        didSet{
            backgroundView.arrowInset=arrowInset
        }
    }
    
    /// 弹出方向
    public var direction:Direction = .vertical(arrow: .auto)
    
    public private(set) var tableView:UITableView = UITableView(frame: .zero, style: .plain)
    
    /// 背景颜色
    public var backgroundColor:UIColor = .white
    
    /// 方向
    public var orientation:UIInterfaceOrientation = .portrait
    
    /// 样式
    public var style:Style = .auto(minWidth: 100.0)
    
    /// 箭头样式
    public var arrowStyle:ArrowStyle = .isosceles(size: CGSize(width: 24, height: 15))
    
//MARK: - private var
    fileprivate var backgroundView = _BKPopoverBackgroundView()
    fileprivate lazy var transition: BKTransition = {
        let trans=BKTransition()
        trans.dismissWhenTouch=true
        trans.orientation=self.orientation
        trans.presentAnimation={[weak self] (transitionContext) in
            guard let toView = transitionContext.view(forKey: .to) else{
                return
            }
            guard self != nil else{
                return
            }
            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0, y: 0)
            toView.layer.anchorPoint=self!.anchorPoint
            UIView.animate(withDuration: 0.25, delay: 0, options: .layoutSubviews, animations: {
                toView.transform=CGAffineTransform(scaleX: 1, y: 1)
            }) { (finished) in
                transitionContext.completeTransition(true)
            }
        }
        trans.dismissAnimation={[weak self] (transitionContext) in
            let fromView = transitionContext.view(forKey: .from)
            UIView.animate(withDuration: 0.15, delay: 0, options: .layoutSubviews, animations: {
                fromView?.transform=CGAffineTransform(scaleX: 0.5, y: 0.5)
                fromView?.alpha = 0.1
            }) { (finished) in
                fromView?.alpha = 1
                transitionContext.completeTransition(true)
            }
        }
        return trans
    }()
    fileprivate var popoverSize:CGSize = .zero
    fileprivate var targetRect:CGRect = .zero
    fileprivate var anchorPoint:CGPoint = .zero
    fileprivate var contentRect:CGRect = .zero

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backgroundView.controller=self
        
        self.tableView.backgroundColor = .clear
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.tableView.layer.cornerRadius = backgroundView.layer.cornerRadius
        self.tableView.clipsToBounds = true
        self.tableView.register(BKPopoverCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(contentRect.minX)
            make.top.equalToSuperview().offset(contentRect.minY)
            make.width.equalTo(contentRect.width)
            make.height.equalTo(contentRect.height)
        }
    }
//MARK: - show 弹出显示方法
    public func show(inController:UIViewController,target:UIView) {
        let frameInWindow = target.screenFrame
        show(inController: inController, rect: frameInWindow)
    }
    public func show(inController:UIViewController,point:CGPoint) {
        show(inController: inController, rect: CGRect(x: point.x, y: point.y, width: 0, height: 0))
    }
    public func show(inController:UIViewController,rect:CGRect) {
        updateContentRect(target: rect)
        self.targetRect = rect
        self.transitioningDelegate = self.transition;
        self.modalPresentationStyle = .custom;
        inController.present(self, animated: true, completion: nil)
    }
    public func show(inController: UIViewController, item: UIBarButtonItem) {
        
    }
//MARK: - update position and size
    func updateContentRect(target:CGRect) {
        var rect = CGRect(x: 0, y: 0, width: popoverSize.width, height: popoverSize.height)
        switch self.direction {
        case .vertical(let arrow):
            rect.origin.x = updateVerticalX(arrow: arrow, target: target)
            if target.maxY+popoverSize.height < SCREEN.HEIGHT {
                rect.origin.y = target.maxY
                anchorPoint=CGPoint(x: (target.midX+arrowInset-rect.minX)/popoverSize.width, y: 0)
                contentRect = CGRect(x: 0, y: self.arrowStyle.size.height, width: rect.width, height: rect.height-self.arrowStyle.size.height)
            }else if target.minY - popoverSize.height > 0 {
                rect.origin.y = target.minY - popoverSize.height
                anchorPoint=CGPoint(x: (target.midX+arrowInset-rect.minX)/popoverSize.width, y: 1)
                contentRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height-self.arrowStyle.size.height)
            }else{
                rect.origin.y = target.maxY
                rect.size.height = SCREEN.HEIGHT-target.maxY
                anchorPoint=CGPoint(x: (target.midX+arrowInset-rect.minX)/popoverSize.width, y: 0)
                contentRect = CGRect(x: 0, y: self.arrowStyle.size.height, width: rect.width, height: rect.height-self.arrowStyle.size.height)
            }
            
        case .horizontal(let arrow):
            rect.origin.y = updateHorizontalY(arrow: arrow, target: target)
            if target.maxX+popoverSize.width < SCREEN.WIDTH {
                rect.origin.x = target.maxX
                anchorPoint=CGPoint(x: 0, y: (target.midY+arrowInset-rect.minY)/popoverSize.height)
                contentRect = CGRect(x: self.arrowStyle.size.width, y: 0, width: rect.width-self.arrowStyle.size.width, height: rect.height)
            }else if target.minX - popoverSize.width > 0 {
                rect.origin.x = target.minX - popoverSize.width
                anchorPoint=CGPoint(x: 1, y: (target.midY+arrowInset-rect.minY)/popoverSize.height)
                contentRect = CGRect(x: 0, y: 0, width: rect.width-self.arrowStyle.size.width, height: rect.height)
            }else{
                rect.origin.x = target.maxX
                rect.size.width = SCREEN.WIDTH - target.maxX
                anchorPoint=CGPoint(x: 0, y: (target.midY+arrowInset-rect.minY)/popoverSize.height)
                contentRect = CGRect(x: self.arrowStyle.size.width, y: 0, width: rect.width-self.arrowStyle.size.width, height: rect.height)
            }
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
            if target.midX-popoverSize.width/2 < 5 {
                return updateVerticalX(arrow: .left, target: target)
            }else if target.midX+popoverSize.width/2 > SCREEN.WIDTH-5{
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
            if target.midY-popoverSize.height/2 < 5 {
                return updateHorizontalY(arrow: .top, target: target)
            }else if target.midY+popoverSize.height/2 > SCREEN.HEIGHT-5{
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
        case .auto(let minWidth):
            var rowsHeight:CGFloat = 0
            self.items.forEach { (item) in
                rowsHeight += item.cellHeight
            }
            height = rowsHeight+self.arrowStyle.size.height;
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
extension BKPopoverViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BKPopoverCell
        cell.item=self.items[indexPath.row]
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.items[indexPath.row].cellHeight
    }
    
}
extension BKPopoverViewController : UITableViewDelegate{
    
}

//MARK: - BackgroundView
class _BKPopoverBackgroundView: UIView {
    weak var controller:BKPopoverViewController?
    var arrowInset:CGFloat = 0 //vertical: x position,horizontal:y position
    var arrowRadius:CGFloat = 2
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        
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
        if controller!.targetRect.minX > controller!.transition.presentRect.minX {//右
            let arrowRect = CGRect(x: self.bounds.maxX-arrowSize.height, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2+arrowInset, width: arrowSize.width, height: arrowSize.height)
            //三角顶角
            let start = CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.midY+arrowRadius)
            context.move(to: start)
            context.addQuadCurve(to: CGPoint(x: arrowRect.maxX-arrowRadius, y: arrowRect.midY-arrowRadius), control: CGPoint(x: arrowRect.maxX, y: arrowRect.midY))
            //三角上边角
            context.addLine(to: CGPoint(x: arrowRect.minX+arrowRadius , y: arrowRect.minY+arrowRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX, y: arrowRect.minY-arrowRadius), control: CGPoint(x: arrowRect.minX, y: arrowRect.minY))
            //边框右上角
            context.addLine(to: CGPoint(x: arrowRect.minX, y: cornerRadius))
            context.addQuadCurve(to: CGPoint(x: arrowRect.minX-cornerRadius, y:0 ), control: CGPoint(x: arrowRect.minX, y:0 ))
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
            let arrowRect = CGRect(x: 0, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2+arrowInset, width: arrowSize.width, height: arrowSize.height)
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
        if controller!.targetRect.minY > controller!.transition.presentRect.minY {//上
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2+arrowInset, y: self.bounds.maxY-arrowSize.height, width: arrowSize.width, height: arrowSize.height)
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
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2+arrowInset, y: 0, width: arrowSize.width, height: arrowSize.height)
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
            context.addQuadCurve(to: CGPoint(x: self.bounds.maxX-cornerRadius, y: arrowRect.maxY), control: CGPoint(x: self.bounds.maxX, y: arrowRect.maxY))
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
            let arrowRect = CGRect(x: self.bounds.maxX-arrowSize.height, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2+arrowInset, width: arrowSize.width, height: arrowSize.height)
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
            let arrowRect = CGRect(x: 0, y: controller!.targetRect.midY-controller!.transition.presentRect.minY-arrowSize.height/2+arrowInset, width: arrowSize.width, height: arrowSize.height)
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
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2+arrowInset, y: self.bounds.maxY-arrowSize.height, width: arrowSize.width, height: arrowSize.height)
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
            let arrowRect = CGRect(x: controller!.targetRect.midX-controller!.transition.presentRect.minX-arrowSize.width/2+arrowInset, y: 0, width: arrowSize.width, height: arrowSize.height)
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

class BKPopoverCell: UITableViewCell {
    var item:BKPopoverItem?{
        didSet{
            self.imageView?.image = item?.image
            self.textLabel?.text = item?.title
            self.textLabel?.font = item?.titleFont
            self.textLabel?.textColor = item?.titleColor
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.textLabel?.font = item?.selectedTitleFont
            self.textLabel?.textColor = item?.selectedColor
        }else{
            self.textLabel?.font = item?.titleFont
            self.textLabel?.textColor = item?.titleColor
        }
    }
    
}
