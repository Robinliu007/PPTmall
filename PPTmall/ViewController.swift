//
//  ViewController.swift
//  PPTmall
//
//  Created by robin on 2018/3/12.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named:"Color1")
        } else {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

