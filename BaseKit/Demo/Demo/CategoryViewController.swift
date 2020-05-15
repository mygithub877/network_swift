//
//  CategoryViewController.swift
//  Demo
//
//  Created by wenjie liu on 2020/5/14.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import BaseKit
class CategoryViewController: UIViewController {
    var bar:BKCategroyBar = BKCategroyBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Hex("a7a7f7")
        // Do any additional setup after loading the view.
        let item1 = Item(title: "纯文字")
        let item2 = Item(title: "普通状态",selectedTitle: "选中状态")
        let item3 = Item(image: UIImage(named: "contact_icon_sex"))
        let item4 = Item(image: UIImage(named: "contact_icon_sex"),selectedImage:UIImage(named: "contact_icon_male"))
        
        let item5 = Item(title: "文字+图片")
        item5.image = UIImage(named: "contact_icon_sex")
        
        let item6 = Item(title: "普通状态文字+图片",selectedTitle: "选中状态文字+图片")
        item6.image = UIImage(named: "contact_icon_sex")
        item6.selectedImage = UIImage(named: "contact_icon_male")

        let item7 = Item(title: "分类7")
        let item8 = Item(title: "分类8")

        bar = BKCategroyBar(items: [item1,item2,item3,item4,item5,item6,item7,item8])
        bar.backgroundColor = .clear
        bar.setFont(UIFont.boldSystemFont(ofSize: 15), state: .selected)
        bar.setTitleColor(.gray, state: .normal)
        bar.setTitleColor(.systemBlue, state: .selected)
        bar.setTitleColor(.yellow, state: .normal, index: 6)
        bar.setTitleColor(.orange, state: .selected, index: 7)
//        bar.setBackgroundColor(.green, state: .normal, index: 6)
//        bar.setBackgroundColor(.systemPink, state: .selected, index: 6)
        bar.selectedMaskStyle = .humpBackground(color: .white)

        self.view.addSubview(bar)
        bar.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
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
            make.centerY.equalToSuperview()
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
