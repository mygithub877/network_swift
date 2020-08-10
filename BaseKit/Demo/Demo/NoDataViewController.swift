//
//  NoDataViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/11.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
class NoDataViewController: UIViewController {
    var isNetworkError:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .hex("f7f7f7")
        self.navigationItem.barColor = UIColor.systemOrange
        // Do any additional setup after loading the view.
        if isNetworkError {
            self.view.netErrorView.errorCode = NSURLErrorNotConnectedToInternet
            self.view.netErrorView.image = UIImage(named: "img_no_network")
            self.view.netErrorView.isHidden = false
            self.view.netErrorView.button.isHidden = false
            self.view.netErrorView.button.setTitle("重新加载", for: .normal)
            self.view.netErrorView.buttonAction = {(sender) in
                print(sender.title(for: .normal)!)
            }
        }else{
//            self.view.noDataView.title = "暂无数据"
//            self.view.noDataView.image = UIImage(named: "no_information")
            self.view.noDataView.isHidden = false
        }
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
