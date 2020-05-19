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
    enum ArrowDirection {
        case top,topLeft,topRight
        case bottom,bottomLeft,bottomRight
        case left,leftTop,leftBottom
        case right,rightTop,rightBottom
    }
    enum Style {
        case auto(rowHeight:CGFloat,width:CGFloat)
        case size(size:CGSize)
    }
    var items:[BKPopoverItem] = []
    var arrowDirection:ArrowDirection = .top
    var tableView:UITableView = UITableView()
    var backgroundColor:UIColor = .white
    var titleColor:UIColor = .darkText
    var orientation:UIInterfaceOrientation = .portrait
    var selectedColor:UIColor = UIColor(white: 230.0/255.0, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
