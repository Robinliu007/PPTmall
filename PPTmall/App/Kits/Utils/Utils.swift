//
//  Utils.swift
//  PPViewIBInspectable
//
//  Created by robin on 2018/3/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation

// 自定义日志输出
func printX(file: String = #file,
            method: String = #function,
            line: Int = #line) {
    #if DEBUG
        print("\(Date()) [\((file as NSString).lastPathComponent):\(line)] \(method): ")
    #endif
}

// 自定义日志输出
func printX<T>(_ message: T,
               file: String = #file,
               method: String = #function,
               line: Int = #line) {
    #if DEBUG
        print("\(Date()) [\((file as NSString).lastPathComponent):\(line)] \(method): \(message)")
    #endif
}

// 返回原始值或默认值
func valueOrDefault(_ objc:Optional<Any>, defaultValue:Any) -> Any{
    guard let value = objc else {
        return defaultValue
    }
    return value
}
