//
//  APITestPost.swift
//  AlamofireAPI
//
//  Created by robinliu on 2018/4/19.
//  Copyright © 2018年 robin.com. All rights reserved.
//

class APITestPost: APINetworkRequest {
    
    override var baseURL: String {
        return "https://httpbin.org/post"
    }
    
    override var method: API_HTTPMethod{
        return .post
    }
    
    override var requestParams: API_Parameters?{
        return [
            "foo": "bar",
            "fo\"o": "b\"ar",
            "f'oo": "ba'r"
        ]
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
                KEY_code: API_HTTP_CODE_FAILURE,
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
