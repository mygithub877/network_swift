//
//  ResponseViewController.swift
//  Demo
//
//  Created by wenjie liu on 2020/7/17.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController {

    @IBOutlet weak var URLLabel: UILabel!
    
    @IBOutlet weak var methodLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var response:NKResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        URLLabel.text=response?.URL?.absoluteString
        methodLabel.text=response?.method
        headerLabel.text=response?.header?.description
        contentLabel.text=response?.description
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
