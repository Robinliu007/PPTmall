//
//  TestModel.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/18.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import ObjectMapper

struct TestModel: APIModel{
    
    let name: String
    var age: Int
    var nickname: String?
    var job: String
    let school: String?
    
    /// JSON -> Model
    init(map: Map) throws {
        name = try map.value("name")
        age  = try map.value("age")
        nickname  = try map.value("nickname")
        job  = try map.value("job")
        school  = try? map.value("school")
    }
    
    /// Model -> JSON
    mutating func mapping(map: Map) {
        name >>> map["name"]
        age >>> map["age"]
        nickname >>> map["nickname"]
        job >>> map["job"]
        school >>> map["school"]
    }

}
