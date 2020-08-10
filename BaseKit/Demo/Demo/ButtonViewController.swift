//
//  ButtonViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/13.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
class ButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .hex("f7f7f7")
        // Do any additional setup after loading the view.
        let btn1=BKButton(style: .horizontal)
        btn1.setImage(UIImage(named: "share_but_facebook"), for: .normal)
        btn1.setTitle("Facebook-水平布局", for: .normal)
        btn1.setTitleColor(.systemBlue, for: .normal)
        btn1.backgroundColor = .systemOrange
        self.view.addSubview(btn1);
        
        let btn2=BKButton(style: .horizontalReverse)
        btn2.setImage(UIImage(named: "share_but_facebook"), for: .normal)
        btn2.setTitle("Facebook-水平反向布局", for: .normal)
        btn2.setTitleColor(.systemBlue, for: .normal)
        btn2.backgroundColor = .systemOrange
        self.view.addSubview(btn2);

        let btn3=BKButton(style: .vertical)
        btn3.setImage(UIImage(named: "share_but_facebook"), for: .normal)
        btn3.setTitle("Facebook-垂直布局", for: .normal)
        btn3.setTitleColor(.systemBlue, for: .normal)
        btn3.backgroundColor = .systemOrange
        self.view.addSubview(btn3);

        let btn4=BKButton(style: .verticalReverse)
        btn4.setImage(UIImage(named: "share_but_facebook"), for: .normal)
        btn4.setTitle("Facebook-垂直反向布局", for: .normal)
        btn4.setTitleColor(.systemBlue, for: .normal)
        btn4.backgroundColor = .systemOrange
        self.view.addSubview(btn4);

        let btn5=BKButton(style: .custom)
        btn5.setImage(UIImage(named: "share_but_facebook"), for: .normal)
        btn5.setTitle("Facebook-自定义位置", for: .normal)
        btn5.imageRect = CGRect(x: 10, y: 10, width: 30, height: 30)
        btn5.titleRect = CGRect(x: 30, y: 40, width: 120, height: 20)
        btn5.setTitleColor(.systemBlue, for: .normal)
        btn5.backgroundColor = .systemOrange
        self.view.addSubview(btn5);

        let btn6=BKButton(style: .horizontal)
        btn6.setImage(UIImage(named: "share_but_facebook"), for: .normal)
        btn6.setTitle("Facebook-自定义间距", for: .normal)
        btn6.setTitleColor(.systemBlue, for: .normal)
        btn6.backgroundColor = .systemOrange
        btn6.margin = 30
        self.view.addSubview(btn6);

        btn1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        btn2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.snp.bottom).offset(30)
        }
        btn3.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn2.snp.bottom).offset(30)
        }
        btn4.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn3.snp.bottom).offset(30)
        }
        btn5.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn4.snp.bottom).offset(30)
        }
        btn6.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn5.snp.bottom).offset(30)
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
