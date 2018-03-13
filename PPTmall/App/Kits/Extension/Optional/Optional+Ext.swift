//
//  Optional+Ext.swift
//  PPViewIBInspectable
//
//  Created by robin on 2018/3/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation

extension Optional {
    func valueOrDefault(defaultValue: Any) -> Any {
        switch(self) {
        case .none:
            return defaultValue
        case .some(let value):
            return value
        }
    }
}
