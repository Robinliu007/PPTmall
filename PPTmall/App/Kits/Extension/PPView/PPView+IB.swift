//
//  PPView+IB.swift
//  PPViewIBInspectable
//
//  Created by robin on 2018/3/12.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import UIKit

fileprivate var KEY_mBgColor: Void?
fileprivate var KEY_borderColor: Void?

protocol AssociatedObjectProtocol {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: Any) -> Any
}

extension AssociatedObjectProtocol{
    // 获取关联对象
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: Any) -> Any {
        guard let value = objc_getAssociatedObject(self, key) else {
            return defaultValue
        }
        return value
    }
}

//@IBDesignable
extension UIView: AssociatedObjectProtocol{
    
    // 背景色
    @IBInspectable open var mBgColor: Int{
        get {
            return getAssociatedObject(&KEY_mBgColor, defaultValue:0) as! Int
        }
        set {
            objc_setAssociatedObject(self, &KEY_mBgColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.backgroundColor = PPColors[newValue]
        }
    }
    
    // 边框宽度
    @IBInspectable open var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    // 边框颜色
    @IBInspectable open var borderColor: Int {
        get {
            return getAssociatedObject(&KEY_borderColor, defaultValue: 0) as! Int
        }
        set {
            objc_setAssociatedObject(self, &KEY_borderColor, newValue, .OBJC_ASSOCIATION_ASSIGN)
            self.layer.borderColor = PPColors[newValue].cgColor
        }
    }
    
    // 圆角弧度
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            if newValue>0 {
                self.layer.masksToBounds = true
            }
        }
    }
    
    // 剪切
    @IBInspectable open var masksToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    // 获取关联对象
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: Any) -> Any {
        guard let value = objc_getAssociatedObject(self, key) else {
            return defaultValue
        }
        return value
    }
}
