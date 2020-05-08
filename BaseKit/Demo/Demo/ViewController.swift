//
//  ViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import BaseKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func alertAction(_ sender: Any) {
//        showAlert("title", msg: "message", buttons: "Btn1","btn2") { (idx) in
//            print("点击索引：\(idx)")
//        }
//        showAlert(.Style1, title: "Title")
        showAlert(.Style1, title: "Title"){(idx) in
            print("点击索引：\(idx)")
        }

    }
    
    @IBAction func sheetAction(_ sender: Any) {
        showSheet("title", msg: "message", cancel: "Cancel", buttons: "Btn1","B2tn") { (idx) in
            print("点击索引：\(idx)")
        }
    }
    
    @IBAction func webAction(_ sender: Any) {
        let web = BKWebViewController()
        web.url = URL(string: "https://www.baidu.com")
        navigationController?.pushViewController(web, animated: true)
    }
    
    
}

