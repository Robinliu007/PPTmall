//
//  APILoginVerifyCode.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/20.
//  Copyright © 2018年 robin.com. All rights reserved.
//

class APILoginVerifyCode: APINetworkRequest {
    
    let phone: String
    
    init(phone: String) {
        self.phone = phone
    }
    
    override var path: String {
        return "r=login/verify-code"
    }
    
    override var requestParams: API_Parameters?{
        return [
            "mp": self.phone
        ]
    }
    
    override var isMockData: Bool {
        return false
    }
    
    override var mockData: APIJSONObject? {
        return [
            KEY_state: [
                KEY_code: API_HTTP_CODE_SUCCESS,
                KEY_msg: "OK"
            ],
            KEY_data: [
                "isRegistAndBind": true
            ]
        ]
    }
}
