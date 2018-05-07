//
//  APITest.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/17.
//  Copyright © 2018年 robin.com. All rights reserved.
//


class APITest: APINetworkRequest {
    
    override var baseURL: String {
        return "https://httpbin.org/get"
    }
    
    override func mappingModel(jsonObject: APIJSONObject) -> Any? {
        return TestModel(JSON: jsonObject)
    }
    
    override var isMockData: Bool {
        return true
    }
    
    override var mockData: APIJSONObject? {
        return [
            KEY_state: [
                KEY_code: API_HTTP_CODE_SUCCESS,
                KEY_msg: "请求成功"
            ],
            KEY_data: [
                "name": "刘彬",
                "age": 28,
                "nickname": "robin",
                "job": "iOS Developer",
            ]
        ]
    }
}
