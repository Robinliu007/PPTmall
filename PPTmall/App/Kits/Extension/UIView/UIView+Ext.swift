//
//  UIView+Ext.swift
//  PPTmall
//
//  Created by robin on 2018/3/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Returns view class with nib loaded from file with the same name
    ///
    /// - Returns: class with all outlets and view set
    public class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self),
                                        owner: nil,
                                        options: nil)![0] as! T
    }
}
