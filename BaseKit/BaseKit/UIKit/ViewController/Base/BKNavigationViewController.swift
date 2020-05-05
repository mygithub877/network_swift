//
//  BKNavigationViewController.swift
//  BaseKit
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

public class BKNavigationViewController: UINavigationController {
    private var bar: BKNavigationBar{
        get{
            return self.navigationBar as! BKNavigationBar
        }
    }
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: BKNavigationBar.self, toolbarClass: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
