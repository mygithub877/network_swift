//
//  CategoryViewController.swift
//  Demo
//
//  Created by wenjie liu on 2020/5/14.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
class CategoryViewController: UIViewController {
    var bar = BKCategroyBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Hex("a7a7f7")
        // Do any additional setup after loading the view.
        let item1 = BKCategroyItem(title: "纯文字")
        let item2 = BKCategroyItem(title: "普通状态",selectedTitle: "选中状态")
        let item3 = BKCategroyItem(image: UIImage(named: "contact_icon_sex"))
        let item4 = BKCategroyItem(image: UIImage(named: "contact_icon_sex"),selectedImage:UIImage(named: "contact_icon_male"))
        
        let item5 = BKCategroyItem(title: "文字+图片")
        item5.image = UIImage(named: "contact_icon_sex")
        
        let item6 = BKCategroyItem(title: "普通状态文字+图片",selectedTitle: "选中状态文字+图片")
        item6.image = UIImage(named: "contact_icon_sex")
        item6.selectedImage = UIImage(named: "contact_icon_male")

        let item7 = BKCategroyItem(title: "分类7")
        let item8 = BKCategroyItem(title: "分类8")

        bar = BKCategroyBar(items: [item1,item2,item3,item4,item5,item6,item7,item8])
        bar.backgroundColor = .clear
        bar.setFont(UIFont.boldSystemFont(ofSize: 15), state: .selected)
        bar.setTitleColor(.gray, state: .normal)
        bar.setTitleColor(.lightText, state: .selected)
        bar.setTitleColor(.yellow, state: .normal, index: 6)
        bar.setTitleColor(.orange, state: .selected, index: 7)
//        bar.setBackgroundColor(.green, state: .normal, index: 6)
//        bar.setBackgroundColor(.systemPink, state: .selected, index: 6)
        self.view.addSubview(bar)
        bar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        let styletitles=["下标线样式","背景样式1","背景样式2","背景样式3","无样式"]
        for i in 0..<styletitles.count {
            let button = UIButton()
            button.setTitle(styletitles[i], for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.tag=i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
            view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().multipliedBy(Float(2*i+1)/Float(styletitles.count))
                make.centerY.equalToSuperview().offset(-100)
            }
        }
        let bgtitles=["Inset","固定大小"]
        for i in 0..<bgtitles.count {
            let button = UIButton()
            button.setTitle(bgtitles[i], for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.tag=i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(bgbuttonActions), for: .touchUpInside)
            view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().multipliedBy(Float(2*i+1)/Float(bgtitles.count))
                make.centerY.equalToSuperview().offset(-60)
            }
        }

        let button = UIButton()
        button.setTitle("随机切换索引", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addAction(event: .touchUpInside) { (sender) in
            let index:Int = Int(arc4random()%7)
            print("index:\(index)")
            self.bar.selectedIndex=index
        }
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
        }
    }
    
    @objc func bgbuttonActions(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            bar.selectedMaskView?.style = .inset(inset: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        case 1:
            bar.selectedMaskView?.style = .size(size: CGSize(width: 40, height: 30))
        default:
            break
        }
    }
    @objc func buttonActions(_ sender:UIButton) {
        switch sender.tag {
        case 0:
            bar.selectedMaskStyle = .line
        case 1:
            bar.selectedMaskStyle = .backgroundView
            bar.selectedMaskView?.image  = UIImage(named: "btn_ad_02")
        case 2:
            bar.selectedMaskView?.backgroundColor = .black
            bar.selectedMaskStyle = .humpBackground(color: .systemGreen)
        case 3:
            bar.selectedMaskStyle = .humpBackground(color: .systemGreen)
            bar.selectedMaskView?.image  = UIImage(named: "btn_ad_02")
        case 4:
            bar.selectedMaskStyle = .without
        default:
            break
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
