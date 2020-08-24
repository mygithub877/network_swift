//
//  ViewController.swift
//  Demo
//
//  Created by liuwenjie on 2020/5/4.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

typealias UITableViewCellHandle = ()->()
typealias UITableViewCellItem = (title:String,subtitle:String,action:UITableViewCellHandle)

class ViewController: UIViewController {
    var index:Int = 0
    var dataSource:[UITableViewCellItem] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        loadDataSources()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
extension ViewController{
    func loadDataSources() {
        
        let item0: UITableViewCellItem = (title:"获取版本号",subtitle:"GET", action:{() in
            NKAuthSession.default.fetchVersion { (response) in
                let vc = ResponseViewController()
                vc.response=response
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        self.dataSource.append(item0)
        
        let item1: UITableViewCellItem = (title:"获取验证码",subtitle:"GET", action:{() in
            NKAuthSession.default.sendCaptcha(phone: "123456789", code: "886") { (response) in
                let vc = ResponseViewController()
                vc.response=response
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        self.dataSource.append(item1)
        let item2: UITableViewCellItem = (title:"登入",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item2)
        let item3: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item3)
        let item4: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item4)
        let item5: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in

        })
        self.dataSource.append(item5)
        let item6: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in

        })
        self.dataSource.append(item6)
        let item7: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in

        })
        self.dataSource.append(item7)
        
        let item8: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in


        })
        self.dataSource.append(item8)
        
        let item9: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in

        })
        self.dataSource.append(item9)
        let item10: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item10)
        let item11: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item11)
        
        let item12: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item12)

        let item13: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item13)

        let item14: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item14)
        let item15: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item15)
        let item16: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item16)

        let item17: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item17)

        let item18: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item18)

        let item19: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item19)

        let item20: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
        })
        self.dataSource.append(item20)
        let item21: UITableViewCellItem = (title:"API",subtitle:"GET", action:{() in
            
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
