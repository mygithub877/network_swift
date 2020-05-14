//
//  GradientViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/13.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import BaseKit
class GradientViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Hex("f7f7f7")
        // Do any additional setup after loading the view.
        let view = BKGradientView()
        self.view.addSubview(view)

        let view1 = BKGradientView()
        view1.style = .linear(.horizontal)
        self.view.addSubview(view1)
        
        let view2 = BKGradientView()
        view2.style = .radial
        self.view.addSubview(view2)

        view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(70)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        view1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(30)
            make.height.width.equalTo(200)
        }
        view2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view1.snp.bottom).offset(30)
            make.height.width.equalTo(200)
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
