//
//  PopoverViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/23.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Hex("a7a7f7")
        
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightItemAction))
        let btn1=UIButton(type: .detailDisclosure)
        btn1.addAction(event: .touchUpInside) {[weak self] (_) in
            self?.centerItemAction()
        }
        self.navigationItem.titleView=btn1
        
        
        let btn2=UIButton(type: .contactAdd)
        btn2.addAction(event: .touchUpInside) {[weak self] (sender) in
            self?.leftBtnAction(sender: sender as! UIButton)
        }
        view.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(30)
        }
        
        let btn3=UIButton(type: .contactAdd)
        btn3.addAction(event: .touchUpInside) {[weak self] (sender) in
            self?.horCenterBtnAction(sender: sender as! UIButton)
        }
        view.addSubview(btn3)
        btn3.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(130)
        }

        let btn4=UIButton(type: .contactAdd)
        btn4.addAction(event: .touchUpInside) {[weak self] (sender) in
            self?.horTopBtnAction(sender: sender as! UIButton)
        }
        view.addSubview(btn4)
        btn4.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(230)
        }

        
        let btn5=UIButton(type: .contactAdd)
        btn5.addAction(event: .touchUpInside) {[weak self] (sender) in
            self?.horBottomBtnAction(sender: sender as! UIButton)
        }
        view.addSubview(btn5)
        btn5.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(330)
        }

        let btn6=UIButton(type: .contactAdd)
        btn6.addAction(event: .touchUpInside) {[weak self] (sender) in
            self?.leftBtnAction(sender: sender as! UIButton)
        }
        view.addSubview(btn6)
        btn6.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-40)
        }

        let btn7=UIButton(type: .contactAdd)
        btn7.addAction(event: .touchUpInside) {[weak self] (sender) in
            self?.horBottomBtnAction(sender: sender as! UIButton)
        }
        view.addSubview(btn7)
        btn7.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-140)
        }

    }
    @objc func rightItemAction() {
        let item1 = BKPopoverItem(title: "row1", image: nil)
        let item2 = BKPopoverItem(title: "row2", image: nil)
        let item3 = BKPopoverItem(title: "row3", image: nil)
        let item4 = BKPopoverItem(title: "row4", image: nil)
        let item5 = BKPopoverItem(title: "row5", image: nil)
        let item6 = BKPopoverItem(title: "row6", image: nil)
        let popover = BKPopoverViewController()
        popover.items = [item1,item2,item3,item4,item5,item6]
        popover.arrowInset = 5
        popover.backgroundColor = .black
        popover.show(inController: self, point: CGPoint(x: self.view.width-35, y: SCREEN.NAV_BAR))
    }
     func centerItemAction() {
        let item1 = BKPopoverItem(title: "row1", image: nil)
        let item2 = BKPopoverItem(title: "row2", image: nil)
        let item3 = BKPopoverItem(title: "row3", image: nil)
        let item4 = BKPopoverItem(title: "row4", image: nil)
        let item5 = BKPopoverItem(title: "row5", image: nil)
        let item6 = BKPopoverItem(title: "row6", image: nil)
        let popover = BKPopoverViewController()
        popover.items = [item1,item2,item3,item4,item5,item6]
        popover.backgroundColor = .black
        popover.direction = .vertical(arrow: .center)
        popover.show(inController: self, point: CGPoint(x: self.view.width/2, y: SCREEN.NAV_BAR))
    }
    func leftBtnAction(sender:UIButton) {
        let item1 = BKPopoverItem(title: "row1", image: nil)
        let item2 = BKPopoverItem(title: "row2", image: nil)
        let item3 = BKPopoverItem(title: "row3", image: nil)
        let item4 = BKPopoverItem(title: "row4", image: nil)
        let item5 = BKPopoverItem(title: "row5", image: nil)
        let item6 = BKPopoverItem(title: "row6", image: nil)
        let popover = BKPopoverViewController()
        popover.items = [item1,item2,item3,item4,item5,item6]
        popover.backgroundColor = .black
        popover.show(inController: self, target: sender)
    }
    func horCenterBtnAction(sender:UIButton) {
        let item1 = BKPopoverItem(title: "row1", image: nil)
        let item2 = BKPopoverItem(title: "row2", image: nil)
        let item3 = BKPopoverItem(title: "row3", image: nil)
        let item4 = BKPopoverItem(title: "row4", image: nil)
        let item5 = BKPopoverItem(title: "row5", image: nil)
        let item6 = BKPopoverItem(title: "row6", image: nil)
        let popover = BKPopoverViewController()
        popover.items = [item1,item2,item3,item4,item5,item6]
        popover.backgroundColor = .black
        popover.direction = .horizontal(arrow: .center)
        popover.arrowStyle = .isosceles(size: CGSize(width: 15, height: 24))
        popover.show(inController: self, target: sender)
    }
    func horTopBtnAction(sender:UIButton) {
        let item1 = BKPopoverItem(title: "row1", image: nil)
        let item2 = BKPopoverItem(title: "row2", image: nil)
        let item3 = BKPopoverItem(title: "row3", image: nil)
        let item4 = BKPopoverItem(title: "row4", image: nil)
        let item5 = BKPopoverItem(title: "row5", image: nil)
        let item6 = BKPopoverItem(title: "row6", image: nil)
        let popover = BKPopoverViewController()
        popover.items = [item1,item2,item3,item4,item5,item6]
        popover.backgroundColor = .black
        popover.direction = .horizontal(arrow: .top)
        popover.arrowStyle = .isosceles(size: CGSize(width: 15, height: 24))
        popover.show(inController: self, target: sender)
    }
    func horBottomBtnAction(sender:UIButton) {
        let item1 = BKPopoverItem(title: "row1", image: nil)
        let item2 = BKPopoverItem(title: "row2", image: nil)
        let item3 = BKPopoverItem(title: "row3", image: nil)
        let item4 = BKPopoverItem(title: "row4", image: nil)
        let item5 = BKPopoverItem(title: "row5", image: nil)
        let item6 = BKPopoverItem(title: "row6", image: nil)
        let popover = BKPopoverViewController()
        popover.items = [item1,item2,item3,item4,item5,item6]
        popover.backgroundColor = .black
        popover.direction = .horizontal(arrow: .bottom)
        popover.arrowStyle = .isosceles(size: CGSize(width: 15, height: 24))
        popover.show(inController: self, target: sender)
    }
}
