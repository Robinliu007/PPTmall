//
//  PPTextView+IB.swift
//  PPViewIBInspectable
//
//  Created by robin on 2018/3/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import UIKit

fileprivate var KEY_mfontSize: Void?
fileprivate var KEY_mfontName: Void?
fileprivate var KEY_mfontColor: Void?

//@IBDesignable
extension UITextView{
    
    // 文本字号大小
    @IBInspectable open var mfontSize: Int{
        get {
            return Int(self.font!.pointSize)
        }
        set {
            var fontName = PPFontName0
            if let value = self.font?.fontName {
                fontName = value
            }
            self.font = PP_fontNameWithSize(fontName, PP_FontSize(newValue))
        }
    }
    
    // 文本字体
    @IBInspectable open var mfontName: Int {
        get {
            return getAssociatedObject(&KEY_mfontName, defaultValue: 0) as! Int
        }
        set {
            objc_setAssociatedObject(self, &KEY_mfontName, newValue, .OBJC_ASSOCIATION_ASSIGN)
            var fontSize = PPFontSize0
            if let value = self.font?.pointSize {
                fontSize = Int(value)
            }
            self.font = PP_fontNameWithSize(PP_FontName(newValue), fontSize)
        }
    }
    
    // 文本颜色
    @IBInspectable open var mfontColor: Int {
        get {
            return getAssociatedObject(&KEY_mfontColor, defaultValue: 0) as! Int
        }
        set {
            objc_setAssociatedObject(self, &KEY_mfontColor, newValue, .OBJC_ASSOCIATION_ASSIGN)
            self.textColor = PPColors[newValue]
        }
    }
}
