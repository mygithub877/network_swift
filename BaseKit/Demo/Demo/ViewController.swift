//
//  ViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import BaseKit
let colors:[UIColor] = [UIColor.systemBlue,UIColor.systemRed,UIColor.systemOrange,UIColor.systemYellow,UIColor.clear]
class ViewController: UIViewController {
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.barColor = colors[index]
        self.view.backgroundColor = UIColor.RGB(r: 230, g: 230, b: 230, alpha: 1)
        self.view.backgroundColor = UIColor.RGB(r: 230, g: 230, b: 230)
        self.view.backgroundColor = .Hex("f7f7f7")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.badgeEnabled = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.badgeText = "\(index)"
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
    
    @IBAction func pushAction(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! ViewController
        vc.index = index+1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func presentAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! ViewController
        let nav = BKNavigationViewController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissAllAction(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController?.dismissAll(animated: true, completion: nil)
    }
}

