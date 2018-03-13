//
//  PPUIConfig.swift
//  PPViewIBInspectable
//
//  Created by robin on 2018/3/12.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import UIKit

/***************** UIColor *******************/
// App经常用到的颜色
let PPColor0 = UIColor.clear
let PPColor1 = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
let PPColor2 = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
let PPColor3 = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
let PPColor4 = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
let PPColor5 = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
let PPColor6 = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
let PPColors : [UIColor] = [PPColor0,
                            PPColor1,
                            PPColor2,
                            PPColor3,
                            PPColor4,
                            PPColor5,
                            PPColor6
]

// 以上颜色index映射为UIColor
public func PP_UIColor(_ index: Int) -> UIColor{
    // 数组越界返回默认颜色
    if index < 0 || index >= PPColors.count {
        return PPColors[1]
    }
    return PPColors[index]
}

// 自定义RGB颜色
public func PP_UIColor(r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

/***************** UIFontSize *******************/
// App经常用的字号大小
let PPFontSize0 = 15
let PPFontSize1 = 18
let PPFontSize2 = 17
let PPFontSize3 = 15
let PPFontSize4 = 13
let PPFontSize5 = 12
let PPFontSize6 = 8
let PPFontSize7 = 38
let PPFontSize8 = 17
let PPFontSize9 = 18
let PPFontSize10 = 19
let PPFontSize11 = 20
let PPFontSize12 = 21
let PPFontSize13 = 22
let PPFontSizes : [Int] = [PPFontSize0,
                           PPFontSize1,
                           PPFontSize2,
                           PPFontSize3,
                           PPFontSize4,
                           PPFontSize5,
                           PPFontSize6,
                           PPFontSize7,
                           PPFontSize8,
                           PPFontSize9,
                           PPFontSize10,
                           PPFontSize11,
                           PPFontSize12,
                           PPFontSize13
]

public func PP_FontSize(_ index: Int) -> Int{
    // 数组越界返回默认颜色
    if index < 0 || index >= PPFontSizes.count {
        return PPFontSizes[0]
    }
    return PPFontSizes[index]
}

/***************** UIFontName *******************/
let PPFontName0 = "HelveticaNeue"
let PPFontName1 = "HelveticaNeue-Light"
let PPFontName2 = "HelveticaNeue-Bold"
let PPFontName3 = "HelveticaNeue"
let PPFontName4 = "HelveticaNeue-Thin"
let PPFontName5 = "HelveticaNeue-UltraLight"
let PPFontNames : [String] = [PPFontName0,
                              PPFontName1,
                              PPFontName2,
                              PPFontName3,
                              PPFontName4,
                              PPFontName5
]

public func PP_FontName(_ index: Int) -> String{
    // 数组越界返回默认颜色
    if index < 0 || index >= PPFontNames.count {
        return PPFontNames[0]
    }
    return PPFontNames[index]
}

public func PP_systemFontWithSize(_ size:Int) -> UIFont{
    return UIFont.systemFont(ofSize: CGFloat(size))
}

public func PP_fontNameWithSize(_ name:String ,_ size:Int) -> UIFont?{
    return UIFont(name:name, size:CGFloat(size))
}
