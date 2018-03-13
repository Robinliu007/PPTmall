//
//  BaseViewController.swift
//  PPTmall
//
//  Created by robin on 2018/3/12.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        printX()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        printX()
    }
    
    deinit {
        printX()
    }
    
}
