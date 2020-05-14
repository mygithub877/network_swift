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
    
    
    
    public var selectedIndex:Int = 0
    
    public var style:Style = .fit
    
    public var badgeTintColor:UIColor = .red
    
    public var titleWidthOffset:CGFloat = 20
    
    public var badgeInsets:UIEdgeInsets = .zero
    
    public var items:[Item]?{
        didSet{
            resetItems()
        }
    }

    private(set) var line:BKCategroyBarLine = BKCategroyBarLine()
    private var scrollView:UIScrollView = UIScrollView()
    private var buttons:[BKCategroyBarButton] = Array<BKCategroyBarButton>()
    
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
    private func setupInit() {
        self.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator=false;
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.bounces=false
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
        scrollView.addSubview(self.line)
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
                line.selectedBtn=btn;
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
    @objc func buttonAction(_ sender:BKCategroyBarButton) {
        guard sender.isSelected == false else {
            return
        }
        sender.isSelected=true
        line.selectedBtn?.isSelected=false;
        line.selectedBtn=sender
        adjustScrollContentOffset()
    }
    func adjustScrollContentOffset() {
        var oldOffset=self.scrollView.contentOffset
        let selectedCenter:CGFloat = (self.line.selectedBtn?.center.x ?? 0) - oldOffset.x
        oldOffset.x =  oldOffset.x+(selectedCenter-self.scrollView.width/2)
        if oldOffset.x<0 {
            oldOffset.x=0
        }else if (oldOffset.x+self.scrollView.width)>self.scrollView.contentSize.width{
            oldOffset.x = self.scrollView.contentSize.width-self.scrollView.width
        }
        self.scrollView.setContentOffset(oldOffset, animated: true)
    }
}
public class BKCategroyBarLine: UIView {
    public enum Style {
        case inset
        case width
        case auto
    }
    public var style:Style = .auto
    public var inset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    public var lineWidth:CGFloat = 0
    public var lineHeight:CGFloat = 2
    fileprivate var selectedBtn:BKCategroyBarButton?{
        didSet{
            oldValue?.removeObserver(self, forKeyPath: "center")
            selectedBtn?.addObserver(self, forKeyPath: "center", options: .new, context: nil)
            updateFrame()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        updateFrame()
    }
    func updateFrame()  {
        var width:CGFloat=0;
        let btnWidth:CGFloat = (selectedBtn?.width ?? 0)
        if (self.style == .auto) {
            width=btnWidth-inset.left-inset.right;
            lineWidth=width
        }else if (self.style == .width){
            width=lineWidth;
        }else{
            width=btnWidth-inset.left-inset.right;
            lineWidth=width
        }
        let rect = CGRect(x:(selectedBtn?.minX ?? 0)+btnWidth/2-width/2, y: (superview?.height ?? 0)-lineHeight, width: width, height: lineHeight)
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
