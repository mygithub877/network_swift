//
//  DashViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/13.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import BaseKit
class DashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Hex("f7f7f7")
        let dash1 = BKDashedView()
        dash1.lineColor = .red
        dash1.lineWidth = 10
        dash1.lineMargin = 5
        self.view.addSubview(dash1)
        dash1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(5)
        }
        let dash2 = BKDashedView()
        dash2.lineColor = .green
        dash2.lineWidth = 10
        dash2.lineMargin = 5
        dash2.lineCap = .round
        self.view.addSubview(dash2)
        dash2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(dash1).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(5)
        }

        let dash3 = BKDashedView()
        dash3.lineColor = .blue
        dash3.lineWidth = 10
        dash3.lineMargin = 5
        dash3.lineCap = .square
        self.view.addSubview(dash3)
        dash3.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(dash2).offset(30)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(5)
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
