//
//  PPConfig.swift
//  PPTmall
//
//  Created by robin on 2018/3/12.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation

func printX(file: String = #file,
            method: String = #function,
            line: Int = #line) {
    #if DEBUG
        print("\(Date()) [\((file as NSString).lastPathComponent):\(line)] \(method): ")
    #endif
}

func printX<T>(_ message: T,
               file: String = #file,
               method: String = #function,
               line: Int = #line) {
    #if DEBUG
        print("\(Date()) [\((file as NSString).lastPathComponent):\(line)] \(method): \(message)")
    #endif
}

