//
//  ViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
let colors:[UIColor] = [UIColor.systemBlue,UIColor.systemTeal,UIColor.systemOrange,UIColor.systemYellow,UIColor.clear]
let barItemTintColors:[UIColor] = [UIColor.white,UIColor.white,UIColor.white,UIColor.red,UIColor.black]

typealias UITableViewCellHandle = ()->()
typealias UITableViewCellItem = (title:String,subtitle:String,action:UITableViewCellHandle)

class ViewController: UIViewController {
    var index:Int = 0
    var dataSource:[UITableViewCellItem] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.barColor = colors[index]
        if colors[index] == UIColor.clear {
            self.edgesForExtendedLayout = .top;
            self.extendedLayoutIncludesOpaqueBars=true;
            if #available(iOS 11.0, *) {
                self.tableView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
//        self.view.backgroundColor = UIColor.RGB(r: 230, g: 230, b: 230, alpha: 1)
//        self.view.backgroundColor = UIColor.RGB(r: 230, g: 230, b: 230)
//        self.view.backgroundColor = .Hex("f7f7f7", alpha: 1)
        self.view.backgroundColor = .hex("f7f7f7")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = barItemTintColors[index]
        self.navigationItem.rightBarButtonItem?.badgeEnabled = true
        
        loadDataSources()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.badgeText = "\(index)"
    }
}
extension ViewController{
    func loadDataSources() {
        
        let item0: UITableViewCellItem = (title:"UIBarButtonItem",subtitle:"badge", action:{() in
            self.navigationItem.rightBarButtonItem?.badgeText = "\(arc4random()%99)"
        })
        self.dataSource.append(item0)
        
        let item1: UITableViewCellItem = (title:"UIViewControllerExtension\n  -Alert",subtitle:"style1", action:{() in
            self.showAlert(.Style1, title: "Title"){(idx) in
                print("点击索引：\(idx)")
            }
        })
        self.dataSource.append(item1)
        let item2: UITableViewCellItem = (title:"UIViewControllerExtension\n  -Alert",subtitle:"style2", action:{() in
            self.showAlert(.Style2, title: "Title"){(idx) in
                print("点击索引：\(idx)")
            }
        })
        self.dataSource.append(item2)
        let item3: UITableViewCellItem = (title:"UIViewControllerExtension\n  -Alert",subtitle:"style3", action:{() in
            self.showAlert(.Style3, title: "Title"){(idx) in
                print("点击索引：\(idx)")
            }
        })
        self.dataSource.append(item3)
        let item4: UITableViewCellItem = (title:"UIViewControllerExtension\n  -ActionSheet",subtitle:"ActionSheet", action:{() in
            self.showSheet("title", msg: "message", cancel: "Cancel", buttons: "Btn1","B2tn") { (idx) in
                print("点击索引：\(idx)")
            }
        })
        self.dataSource.append(item4)
        let item5: UITableViewCellItem = (title:"BKWebViewController",subtitle:"WKWebView", action:{() in
            let web = BKWebViewController()
            web.url = URL(string: "https://www.baidu.com")
            self.navigationController?.pushViewController(web, animated: true)
        })
        self.dataSource.append(item5)
        let item6: UITableViewCellItem = (title:"BKNavigationViewController\n+BKNavigationBar",subtitle:"Push", action:{() in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! ViewController
            if self.index == colors.count-1{
                vc.index = 0
            }else{
                vc.index = self.index+1
            }
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item6)
        let item7: UITableViewCellItem = (title:"BKNavigationViewController\n+BKNavigationBar",subtitle:"Present", action:{() in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! ViewController
            let nav = BKNavigationViewController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        })
        self.dataSource.append(item7)
        
        let item8: UITableViewCellItem = (title:"Dismiss",subtitle:"Dismiss", action:{() in
            self.dismiss(animated: true, completion: nil)
        })
        self.dataSource.append(item8)
        
        let item9: UITableViewCellItem = (title:"UIViewControllerExtension",subtitle:"Dismiss All", action:{() in
            UIApplication.shared.keyWindow?.rootViewController?.dismissAll(animated: true, completion: nil)
        })
        self.dataSource.append(item9)
        let item10: UITableViewCellItem = (title:"UIViewControllerExtension\n  -Toast",subtitle:"Text", action:{() in
            self.showToast("Toast") {
                print("消失")
            }
        })
        self.dataSource.append(item10)
        let item11: UITableViewCellItem = (title:"UIViewControllerExtension\n  -Toast",subtitle:"Text and Title", action:{() in
            self.showToast("Title", text: "Text") {
                print("消失")
            }
        })
        self.dataSource.append(item11)
        
        let item12: UITableViewCellItem = (title:"UIViewExtension\n  -NoDataView",subtitle:"Network Error", action:{() in
            let vc = NoDataViewController()
            vc.isNetworkError = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item12)

        let item13: UITableViewCellItem = (title:"UIViewExtension\n  -NoDataView",subtitle:"No Data View", action:{() in
            let vc = NoDataViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item13)

        let item14: UITableViewCellItem = (title:"UIViewExtension\n  -ActivityIndicatorView",subtitle:"horizontal", action:{() in
            let vc = IndicatorViewController()
            vc.style = .horizontal
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item14)
        let item15: UITableViewCellItem = (title:"UIViewExtension\n   -ActivityIndicatorView",subtitle:"vertical", action:{() in
            let vc = IndicatorViewController()
            vc.style = .vertical
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item15)
        let item16: UITableViewCellItem = (title:"UIViewExtension\n  -ActivityIndicatorView",subtitle:"without label", action:{() in
            let vc = IndicatorViewController()
            vc.style = .withoutLabel
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item16)

        let item17: UITableViewCellItem = (title:"BKButton",subtitle:"button", action:{() in
            let vc = ButtonViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item17)

        let item18: UITableViewCellItem = (title:"BKDashedView",subtitle:"Dash Line", action:{() in
            let vc = DashViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item18)

        let item19: UITableViewCellItem = (title:"BKGradientView",subtitle:"Gradient", action:{() in
            let vc = GradientViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item19)

        let item20: UITableViewCellItem = (title:"BKCategoryBar",subtitle:"category", action:{() in
            let vc = CategoryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item20)
        let item21: UITableViewCellItem = (title:"BKPopoverViewController",subtitle:"popover", action:{() in
            let vc = PopoverViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.dataSource.append(item21)

    }
}



//MARK: - delegate & datasource
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.textLabel?.numberOfLines = 0
        }
        cell?.textLabel?.text = self.dataSource[indexPath.row].title
        cell?.detailTextLabel?.text = self.dataSource[indexPath.row].subtitle
        return cell!
    }
}
extension ViewController:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dataSource[indexPath.row].action()
    }
}
