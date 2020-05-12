//
//  BKButton.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKButton: UIButton {

    public enum Style {
        case horizontal
        case horizontalReverse
        case vertical
        case verticalReverse
        case custom
    }
    public struct Item {
        public var title:String?
        public var normalImage:UIImage?
        public var selectedImage:UIImage?
        public var highlightImage:UIImage?
        public var className:String?
        public init(){
        }
        public init(title:String?,normalImage:UIImage?) {
            self.title=title
            self.normalImage=normalImage
        }
        public init(title:String?,normalImage:UIImage?,className:String) {
            self.title=title
            self.normalImage=normalImage
            self.className=className
        }
    }
    public var margin:CGFloat = 10.0{
        didSet{
            self.setNeedsLayout()
        }
    }
    public var style:Style = .horizontal{
        didSet{
            self.setNeedsLayout()
        }
    }
    public var titleRect:CGRect = CGRect.zero{
        didSet{
            self.setNeedsLayout()
        }
    }
    public var imageRect:CGRect = CGRect.zero{
        didSet{
            self.setNeedsLayout()
        }
    }
    public var item:Item?
    private var titleSize:CGSize?
    init(style:Style) {
        super.init(frame:.zero)
        self.style=style
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override var intrinsicContentSize: CGSize{
        var size = super.intrinsicContentSize
        switch style {
        case .horizontal: fallthrough
        case .horizontalReverse:
            size.width += self.margin
        case .vertical: fallthrough
        case .verticalReverse:
            let vh=(self.imageView?.height ?? 0) + (self.titleLabel?.height ?? 0) + self.margin;
            size=CGSize(width:max(self.imageView?.width ?? 0, self.titleLabel?.width ?? 0),height: vh);
        case .custom:
            self.imageView?.frame = self.imageRect;
            self.titleLabel?.frame = self.titleRect;
            let width=max(self.titleRect.maxX, self.imageRect.maxX);
            let height=max(self.titleRect.maxY, self.imageRect.maxY);
            size=CGSize(width:width, height:height);
        }
        size.width += 20;
        return size
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.sizeToFit()
        self.imageView?.sizeToFit()
        switch style {
        case .horizontal:
            let hw=(self.imageView?.width ?? 0.0)+(self.titleLabel?.width ?? 0.0) + margin;
            self.imageView?.frame=CGRect(x:self.width/2-hw/2, y:self.imageView?.minY ?? 0.0, width:self.imageView?.width ?? 0.0, height:self.imageView?.height ?? 0.0);
            self.titleLabel?.frame=CGRect(x:(self.imageView?.maxX ?? 0.0)+margin, y:(self.titleLabel?.minY ?? 0.0), width:self.titleLabel?.width ?? 0.0, height:self.titleLabel?.height ?? 0.0);
        case .horizontalReverse:
            let hw=(self.imageView?.width ?? 0.0)+(self.titleLabel?.width ?? 0.0) + margin;
            self.titleLabel?.frame=CGRect(x:self.width/2-hw/2, y:self.titleLabel?.minY ?? 0.0, width:self.titleLabel?.width ?? 0.0, height:self.titleLabel?.height ?? 0.0);
            self.imageView?.frame=CGRect(x:(self.titleLabel?.maxX ?? 0.0)+margin, y:(self.imageView?.minY ?? 0.0), width:self.imageView?.width ?? 0.0, height:self.imageView?.height ?? 0.0);
        case .vertical:
            let vh=(self.imageView?.height ?? 0.0)+(self.titleLabel?.height ?? 0.0) + margin;
            self.imageView?.frame=CGRect(x:self.width/2-(self.imageView?.width ?? 0.0)/2, y:self.height/2-vh/2, width:self.imageView?.width ?? 0, height:self.imageView?.height ?? 0.0);
            self.titleLabel?.frame=CGRect(x:self.width/2-(self.titleLabel?.width ?? 0.0)/2, y:(self.imageView?.maxY ?? 0.0)+margin, width:self.titleLabel?.width ?? 0.0, height:self.titleLabel?.height ?? 0.0);

        case .verticalReverse:
            let vh=(self.imageView?.height ?? 0.0)+(self.titleLabel?.height ?? 0.0) + margin;
            self.titleLabel?.frame=CGRect(x:self.width/2-(self.titleLabel?.width ?? 0.0)/2, y:self.height/2-vh/2, width:self.titleLabel?.width ?? 0.0, height:self.titleLabel?.height ?? 0.0);
            
            self.imageView?.frame=CGRect(x:self.width/2-(self.imageView?.width ?? 0.0)/2, y:(self.imageView?.maxY ?? 0.0)+margin, width:self.imageView?.width ?? 0.0, height:self.imageView?.height ?? 0.0);

        case .custom:
            self.imageView?.frame = self.imageRect;
            self.titleLabel?.frame = self.titleRect;
        }

    }
}

