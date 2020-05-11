//
//  BKActivityIndicatorLoadView.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKActivityIndicatorLoadView: UIView {
    public enum Style {
        case horizontal
        case vertical
        case withoutLabel
    }
    private(set) var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    public private(set) var label:UILabel = UILabel()
    public  var style:Style = .horizontal{
        didSet{
            self.sizeToFit()
            self.updateUI()
        }
    }
    public override var intrinsicContentSize: CGSize{
        let lblSize = label.sizeThatFits(CGSize(width: SCREEN.WIDTH, height: 30))
        if style == .horizontal {
            return CGSize(width: lblSize.width+30, height: 30)
        }else if style == .vertical{
            return CGSize(width: max(lblSize.width,30), height: 50)
        }else{
            return CGSize(width: 30, height: 30)
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    public init(style:Style) {
        super.init(frame: .zero)
        self.style = style
        setupUI()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    func setupUI() {
        self.isHidden=true
        self.addSubview(indicatorView)
        indicatorView.hidesWhenStopped=true
        indicatorView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            if style == .horizontal{
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
            }else{
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
        }
        
        if style != .withoutLabel {
            self.addSubview(label)
            label.textAlignment = .center
            label.textColor = .gray
            label.text = "加载中..."
            label.font = .systemFont(ofSize: 14)
            label.snp.makeConstraints { (make) in
                if style == .horizontal{
                    make.centerY.equalToSuperview()
                    make.left.equalTo(indicatorView.snp.right).offset(5)
                }else{
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
    func updateUI() {
        indicatorView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(25)
            if style == .horizontal{
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
            }else{
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
        }
        if style != .withoutLabel {
            label.snp.remakeConstraints { (make) in
                if style == .horizontal{
                    make.centerY.equalToSuperview()
                    make.left.equalTo(indicatorView.snp.right).offset(5)
                }else{
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
        }else{
            self.label.removeFromSuperview()
        }

    }
    func startAnimating() {
        indicatorView.startAnimating()
        self.isHidden=false
    }
    func stopAnimating() {
       indicatorView.stopAnimating()
       self.isHidden=true
   }
}
