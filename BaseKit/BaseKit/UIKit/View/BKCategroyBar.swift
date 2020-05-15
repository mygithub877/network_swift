//
//  BKCategroyBar.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
public class BKCategroyBar: UIView {
    public enum Style {
        case fit
        case full
    }
    public enum SelectedStyle {
        case line
        case backgroundView
        case humpBackground(color:UIColor)
        case without
    }
    public var selectedIndex:Int = 0{
        didSet{
            updateSelectedIndex()
        }
    }
    public var style:Style = .fit {
        didSet{
            resetItems()
        }
    }
    public var titleWidthOffset:CGFloat = 20 {
        didSet{
            resetItems()
        }
    }
    public var items:[Item]?{
        didSet{
            resetItems()
        }
    }
    public var selectedMaskStyle:SelectedStyle = .line {
        didSet{
            resetSelectMaskView()
        }
    }
    public var badgeInsets:UIEdgeInsets = .zero
    public var badgeTintColor:UIColor = .red

    private(set) var selectedMaskView:BKCategroyBarSelectedView?

    private var scrollView:BKCategroyBarScrollView = BKCategroyBarScrollView()
    private var buttons:[BKCategroyBarButton] = Array<BKCategroyBarButton>()
    //MARK: - functions
    public func setFont(_ font:UIFont,state:UIControl.State,index:Int? = nil){
        guard self.items != nil else {
            return
        }
        guard state != .highlighted else {
            return
        }
        if index == nil{
            var idx = 0
            self.items!.forEach({ (item) in
                item.fonts[state.rawValue]=font
                if buttons.count > idx {
                    buttons[idx].item=item
                }
                idx += 1
            })
        }else{
            guard self.items!.count > index! else {
                return
            }
            self.items![index!].fonts[state.rawValue]=font;
            if buttons.count > index! {
                buttons[index!].item=self.items![index!]
            }
        }
        
    }
    public func setTitleColor(_ color:UIColor,state:UIControl.State,index:Int? = nil){
        guard self.items != nil else {
            return
        }
        guard state != .highlighted else {
            return
        }
        if index == nil{
            var idx = 0
            self.items!.forEach({ (item) in
                item.titleColors[state.rawValue]=color
                if buttons.count > idx {
                    buttons[idx].item=item
                }
                idx += 1
            })
        }else{
            guard self.items!.count > index! else {
                return
            }
            self.items![index!].titleColors[state.rawValue]=color;
            if buttons.count > index! {
                buttons[index!].item=self.items![index!]
            }
        }
    }
    public func setBackgroundColor(_ color:UIColor?,state:UIControl.State,index:Int? = nil){
        guard self.items != nil else {
            return
        }
        guard state != .highlighted else {
            return
        }
        if index == nil{
            var idx = 0
            self.items!.forEach({ (item) in
                item.backgroundColors[state.rawValue]=color
                if buttons.count > idx {
                    buttons[idx].item=item
                }
                idx += 1
            })
        }else{
            guard self.items!.count > index! else {
                return
            }
            self.items![index!].backgroundColors[state.rawValue]=color;
            if buttons.count > index! {
                buttons[index!].item=self.items![index!]
            }
        }
    }
    public func setBackgroundImage(_ image:UIImage?,state:UIControl.State,index:Int? = nil){
        guard self.items != nil else {
            return
        }
        guard state != .highlighted else {
            return
        }
        if index == nil{
            var idx = 0
            self.items!.forEach({ (item) in
                item.backgroundImages[state.rawValue]=image
                if buttons.count > idx {
                    buttons[idx].item=item
                }
                idx += 1
            })
        }else{
            guard self.items!.count > index! else {
                return
            }
            self.items![index!].backgroundImages[state.rawValue]=image;
            if buttons.count > index! {
                buttons[index!].item=self.items![index!]
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame:frame)
        setupInit()
    }
    public init(items:[Item]) {
        super.init(frame:.zero)
        setupInit()
        self.items=items
        resetItems()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInit()
    }
}
private extension BKCategroyBar{
    private func setupInit() {
        self.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator=false;
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.bounces=false
        scrollView.backgroundColor = .clear
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalToSuperview()
        }
    }
    private func resetItems() {
        self.scrollView.removeAllSubViews()
        buttons.removeAll()
        guard (self.items?.isEmpty ?? true) == false else {
            return
        }
        resetSelectMaskView()
        var totalWidth:CGFloat = 0
        let offset=titleWidthOffset
        var index = 0
        self.items?.forEach({ (item) in
            let btn=BKCategroyBarButton()
            btn.tag=index;
            btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            btn.item=item
            scrollView.addSubview(btn)
            buttons.append(btn)
            btn.sizeToFit()
            totalWidth += (btn.width+offset)
            if index == self.selectedIndex{
                btn.isSelected=true;
                selectedMaskView?.selectedBtn=btn;
            }
            index += 1
        })
        var offset_full:CGFloat = 0
        if (totalWidth<self.width) {
            offset_full=(self.width-totalWidth)/CGFloat(items!.count)+offset;
        }else{
            let wset=(totalWidth-self.width)/CGFloat(items!.count);
            offset_full=offset-wset;
        }
        var preBtn:BKCategroyBarButton?
        buttons.forEach({ (btn) in
            if self.style == .fit {
                btn.maiginOffset = offset
            }else{
                btn.maiginOffset = offset_full
            }
            btn.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalToSuperview()
                if preBtn == nil{
                    make.left.equalToSuperview()
                }else{
                    make.left.equalTo(preBtn!.snp.right)
                }
            }
            preBtn=btn;
        })
        preBtn!.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
        }
    }
    func resetSelectMaskView() {
        self.selectedMaskView?.removeFromSuperview()
        scrollView.selectedView=nil
        switch self.selectedMaskStyle {
        case .line:
            self.selectedMaskView = BKCategroyBarLine()
        case .backgroundView:
            self.selectedMaskView = BKCategroyBarBackgroundView()
        case .humpBackground(let color):
            let v = BKCategroyBarBackgroundView()
            v.humpFillColor = color
            scrollView.selectedView=v
            self.selectedMaskView = v
        default:
            self.selectedMaskView = nil
        }
        if self.selectedMaskView != nil {
            scrollView.insertSubview(self.selectedMaskView!, at: 0)
            if buttons.count > selectedIndex {
                selectedMaskView?.selectedBtn=buttons[selectedIndex];
            }
        }

    }
    @objc func buttonAction(_ sender:BKCategroyBarButton) {
        guard sender.isSelected == false else {
            return
        }
        selectedIndex = sender.tag
        updateSelectButton(sender)
    }
    func updateSelectedIndex() {
        guard buttons.count > selectedIndex else {
            return
        }
        let btn = buttons[selectedIndex]
        guard btn.isSelected == false else {
            return
        }
        updateSelectButton(btn)
    }
    func updateSelectButton(_ btn:BKCategroyBarButton) {
        btn.isSelected=true
        selectedMaskView?.selectedBtn?.isSelected=false;
        selectedMaskView?.selectedBtn=btn
        adjustScrollContentOffset()
        scrollView.setNeedsDisplay()
    }
    func adjustScrollContentOffset() {
        var oldOffset=self.scrollView.contentOffset
        let selectedCenter:CGFloat = (self.selectedMaskView?.selectedBtn?.center.x ?? 0) - oldOffset.x
        oldOffset.x =  oldOffset.x+(selectedCenter-self.scrollView.width/2)
        if oldOffset.x<0 {
            oldOffset.x=0
        }else if (oldOffset.x+self.scrollView.width)>self.scrollView.contentSize.width{
            oldOffset.x = self.scrollView.contentSize.width-self.scrollView.width
        }
        self.scrollView.setContentOffset(oldOffset, animated: true)
    }
}

class BKCategroyBarScrollView: UIScrollView {
    var selectedView:BKCategroyBarBackgroundView?{
        didSet{
            oldValue?.removeObserver(self, forKeyPath: "frame")
            self.selectedView?.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            setNeedsDisplay()
        }
    }
    deinit {
        selectedView?.removeObserver(self, forKeyPath: "frame")
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setNeedsDisplay()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let maskview = self.selectedView else {
            return
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        var maskFrame = maskview.frame
        let cor = maskFrame.height/2
        let cap:CGFloat = 2
        maskFrame.origin.x -= (cap);
        maskFrame.origin.y -= cap;
        maskFrame.size.width += 2*cap;
        maskFrame.size.height += cap;
        
        //左下
        context.move(to: CGPoint(x: maskFrame.minX-cor, y: maskFrame.maxY))
        context.addQuadCurve(to: CGPoint(x: maskFrame.minX, y: maskFrame.midY), control: CGPoint(x: maskFrame.minX-cap*0.5, y: maskFrame.maxY-cap*0.5))
        context.addLine(to: CGPoint(x: maskFrame.minX, y: maskFrame.midY))
        //左上
        context.addQuadCurve(to: CGPoint(x: maskFrame.minX+cor, y: maskFrame.minY), control: CGPoint(x: maskFrame.minX+cap*0.7, y: maskFrame.minY+cap*0.7))
        context.addLine(to: CGPoint(x: maskFrame.maxX-cor, y: maskFrame.minY))
        //右上
        context.addQuadCurve(to: CGPoint(x: maskFrame.maxX, y: maskFrame.midY), control: CGPoint(x: maskFrame.maxX-cap*0.5, y: maskFrame.minY+cap*0.5))
        context.addLine(to: CGPoint(x: maskFrame.maxX, y: maskFrame.midY))
        //右下
        context.addQuadCurve(to: CGPoint(x: maskFrame.maxX+cor, y: maskFrame.maxY), control: CGPoint(x: maskFrame.maxX+cap*0.5, y: maskFrame.maxY-cap*0.5))
        
        context.addLine(to: CGPoint(x: contentSize.width, y: maskFrame.maxY))
        context.addLine(to: CGPoint(x: contentSize.width, y: 0))
        context.addLine(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: maskFrame.maxY))
        context.addLine(to: CGPoint(x: maskFrame.minX-cor, y: maskFrame.maxY))
        context.setFillColor(maskview.humpFillColor.cgColor)
        context.fillPath()
    }
    
}



public class BKCategroyBarSelectedView: UIView{
    public enum Style {
        case inset
        case size
        case auto
    }
    public enum AnimationCurve {
        case easeInOut
        case easeIn
        case easeOut
        case linear
        case spring
        case none
    }
    public var image:UIImage?
    public var style:Style = .auto
    public var inset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    public var lineSize:CGSize = CGSize(width: 0, height: 2)
    fileprivate var selectedBtn:BKCategroyBarButton?{
        didSet{
            oldValue?.removeObserver(self, forKeyPath: "center")
            self.selectedBtn?.addObserver(self, forKeyPath: "center", options: .new, context: nil)
            
            self.updateFrame()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    deinit {
        selectedBtn?.removeObserver(self, forKeyPath: "center")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        updateFrame()
    }
    open func updateFrame()  {
        
    }
}
 

public class BKCategroyBarLine: BKCategroyBarSelectedView {
    
    override public func updateFrame()  {
        super.updateFrame()
        var width:CGFloat=0;
        let btnWidth:CGFloat = (selectedBtn?.width ?? 0)
        var x:CGFloat = 0
        var y:CGFloat = 0
        if (self.style == .auto) {
            width=btnWidth-inset.left-inset.right;
            lineSize.width=width
            x=(selectedBtn?.minX ?? 0)+inset.left
            y = (superview?.height ?? 0)-lineSize.width-inset.bottom
        }else if (self.style == .size){
            width=lineSize.width;
            x = (selectedBtn?.minX ?? 0)+btnWidth/2-width/2
            y = (superview?.height ?? 0)-lineSize.height
        }else{
            width=btnWidth-inset.left-inset.right;
            lineSize.width=width
            x=(selectedBtn?.minX ?? 0)+inset.left
            y = (superview?.height ?? 0)-lineSize.height-inset.bottom
        }

        let rect = CGRect(x:x, y: y, width: width, height: lineSize.height)
        self.frame = rect
    }
}
public class BKCategroyBarBackgroundView: BKCategroyBarSelectedView {
    var humpFillColor:UIColor = .white
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        inset = UIEdgeInsets(top: 12.5, left: 10, bottom: 12.5, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func updateFrame()  {
        super.updateFrame()
        var width:CGFloat=0;
        var height:CGFloat=0;
        let btnWidth:CGFloat = (selectedBtn?.width ?? 0)
        let btnHeight:CGFloat = (selectedBtn?.height ?? 0)
        var x:CGFloat = 0
        var y:CGFloat = 0

        if (self.style == .auto) {
            width=btnWidth-inset.left-inset.right;
            height=btnHeight-inset.top-inset.bottom;
            lineSize.height=height
            lineSize.width=width
            x=(selectedBtn?.minX ?? 0)+inset.left
            y=inset.top
        }else if (self.style == .size){
            width=lineSize.width;
            height=lineSize.height
            x = (selectedBtn?.minX ?? 0)+btnWidth/2-width/2
            y=btnHeight/2-lineSize.height/2;
        }else{
            width=btnWidth-inset.left-inset.right;
            height=btnHeight-inset.top-inset.bottom
            lineSize.height=height
            lineSize.width=width
            x=(selectedBtn?.minX ?? 0)+inset.left
            y=inset.top
        }
        let rect = CGRect(x:x, y: y, width: width, height: lineSize.height)
        self.layer.cornerRadius = lineSize.height/2
        self.frame = rect
    }
}
public class Item: NSObject{
    
    public var title:String?
    public var selectedTitle:String?
    
    public var image:UIImage?
    public var selectedImage:UIImage?
    
    fileprivate var badgeText:String = ""
    
    fileprivate var fonts:[UInt:UIFont] = [UIControl.State.normal.rawValue:UIFont.systemFont(ofSize: 14),UIControl.State.selected.rawValue:UIFont.systemFont(ofSize: 14)]
    fileprivate var titleColors:[UInt:UIColor] = [UIControl.State.normal.rawValue:UIColor.black,UIControl.State.selected.rawValue:UIColor.red,UIControl.State.highlighted.rawValue:UIColor.red]
    fileprivate var backgroundColors:[UInt:UIColor] = [:]
    fileprivate var backgroundImages:[UInt:UIImage] = [:]

    public init(title:String?,selectedTitle:String? = nil) {
        super.init()
        self.title=title
        self.selectedTitle=selectedTitle
    }
    public init(image:UIImage?,selectedImage:UIImage? = nil) {
        super.init()
        self.image=image
        self.selectedImage=selectedImage
    }
}
class BKCategroyBarButton: UIButton {
    //MARK: - Property
    var item:Item?{
        didSet{
            self.badgeLabel.text=item?.badgeText
            setTitle(item?.title, for: .normal)
            setTitle(item?.selectedTitle, for: .selected)

            setImage(item?.image, for: .normal)
            setImage(item?.selectedImage, for: .selected)

            updateUI()
        }
    }
    var maiginOffset:CGFloat?
    override var intrinsicContentSize: CGSize{
        let size = super.intrinsicContentSize
        if maiginOffset != nil{
            return CGSize(width: size.width+maiginOffset!*2, height: size.height)
        }
        return size
    }
    override var isSelected: Bool{
        didSet{
            updateUI()
        }
    }
    override var isHighlighted: Bool{
        set{
            //禁用高亮
        }
        get{
            return super.isHighlighted
        }
    }
    override var isEnabled: Bool{
        didSet{
            updateUI()
        }
    }
    override var isUserInteractionEnabled: Bool{
        didSet{
            updateUI()
        }
    }
    lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red;
        label.font=UIFont.systemFont(ofSize: 10);
        label.textColor = .white;
        label.clipsToBounds=true;
        label.textAlignment = .center;
        label.isHidden = true
        return label
    }()
    //MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.badgeLabel);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)
        rect.origin.x -= 2.5
        return rect
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        rect.origin.x += 2.5
        return rect
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let badgeSize = self.unReadLabelSize()
        if (self.titleLabel?.text?.isEmpty ?? true) &&  self.imageView?.image != nil {
            self.badgeLabel.frame = CGRect(x: (self.imageView?.maxX ?? 0), y: (self.imageView?.minY ?? 0)-badgeSize.height/2, width: badgeSize.width, height: badgeSize.height)
        }else{
            self.badgeLabel.frame = CGRect(x: (self.titleLabel?.maxX ?? 0), y: (self.titleLabel?.minY ?? 0)-badgeSize.height/2, width: badgeSize.width, height: badgeSize.height)
        }
        self.badgeLabel.layer.cornerRadius = badgeSize.height/2
    }
    //MARK: - UI
    func updateUI() {
        self.item?.titleColors.forEach({ (key, value) in
            let st=UIControl.State(rawValue: key)
            setTitleColor(value, for: st)
        })
        self.item?.backgroundImages.forEach({ (key,value) in
            setBackgroundImage(value, for: UIControl.State(rawValue: key))
        })
        var font = self.item?.fonts[self.state.rawValue]
        if font == nil {
            font = self.item?.fonts[UIControl.State.normal.rawValue]
        }
        self.titleLabel?.font = font;
        let backgroundColor = self.item?.backgroundColors[self.state.rawValue]
        self.backgroundColor = backgroundColor
    }
    
    func unReadLabelSize() -> CGSize{
        self.badgeLabel.sizeToFit()
        let size=self.badgeLabel.frame.size
        let maxHeight=CGFloat(15.0);
        let minWidth=CGFloat(maxHeight);
        var width=size.width+8.0;
        if (width<minWidth) {
            width=minWidth;
        }
        return CGSize(width:width, height:maxHeight);
    }

}
