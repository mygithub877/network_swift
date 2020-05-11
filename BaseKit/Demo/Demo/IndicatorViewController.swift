//
//  IndicatorViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/11.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import BaseKit
class IndicatorViewController: UIViewController {
    var style:BKActivityIndicatorLoadView.Style = .horizontal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Hex("f7f7f7")
        self.navigationItem.barColor = UIColor.systemTeal
        self.view.activityIndicatorView.style = self.style
        self.view.showActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.view.hiddenActivityIndicator()
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
