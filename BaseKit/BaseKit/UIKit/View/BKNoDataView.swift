//
//  BKNoDataView.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/10.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKNoDataView: UIView {
    
    public var title:String = "" {
        didSet{
            let para = NSMutableParagraphStyle()
            para.lineSpacing = 6
            para.alignment = .center;
            let attrstr = NSAttributedString(string: title, attributes: [.paragraphStyle:para])
            titleLabel.attributedText = attrstr
            titleLabel.sizeToFit()
            self.sizeToFit()
        }
    }
    public var image:UIImage?{
        didSet{
            self.imageView.image = image
            self.imageView.sizeToFit()
            self.sizeToFit()
        }
    }
    public var errorCode:Int = 0 {
        didSet{
            switch errorCode {
                case NSURLErrorNotConnectedToInternet:
                    self.title = "網路連接失敗";
                    break;
                case NSURLErrorTimedOut:
                    self.title = "網路請求超時";
                    break;
                case NSURLErrorNetworkConnectionLost:
                    self.title = "網路連接失敗";
                    break;
                case NSURLErrorCannotConnectToHost:
                    self.title = "無法連結到伺服器";
                    break;
                default:
                    break;
            }

        }
    }
    public private(set) var button = BKNoDataButton() as UIButton
    public private(set) var imageView = UIImageView()
    public private(set) var titleLabel = UILabel()
    public var buttonAction:((_ sender:UIButton)->())?
    public var centerYConstrait:NSLayoutConstraint?
    public var centerXConstrait:NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    public override var intrinsicContentSize: CGSize{
        let width = max(titleLabel.width, imageView.width)
        var height = titleLabel.height+imageView.height+30
        if button.isHidden == false {
            height += 80
        }
        return CGSize(width: width, height: height)
    }
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .Hex("999999")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.preferredMaxLayoutWidth = SCREEN.WIDTH-20;
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(10)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10);
            make.centerX.equalTo(self.snp.centerX);
            make.width.lessThanOrEqualTo(SCREEN.WIDTH-20)
        }
        button.isHidden = true
        (button as! BKNoDataButton).didLayoutSubviews = {
            self.sizeToFit()
        }
        button.addTarget(self, action: #selector(_buttonAction), for: .touchUpInside)
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(17.5)
        }
        button.addObserver(self, forKeyPath: "isHidden", options: .new, context: nil)
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isHidden" {
            self.sizeToFit()
        }
    }
    @objc func _buttonAction(_ sender:UIButton) {
        if self.buttonAction != nil {
            self.buttonAction!(sender)
        }
    }
}

private class BKNoDataButton : UIButton{
    var didLayoutSubviews:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.layer.cornerRadius = 45.0/2.0
        self.clipsToBounds = true
        self.backgroundColor = .Hex("3a83e8")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize{
        var size = super.intrinsicContentSize
        size.width += 60
        return size
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if didLayoutSubviews != nil {
            didLayoutSubviews!()
        }
    }
}
