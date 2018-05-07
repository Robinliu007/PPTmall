//
//  APIRequest.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - 请求结果

enum APIResult<Request: APINetworkBaseRequest> {
    case success(Request)
    case failure(Request, APIError)
    
    /// 是否成功
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// 是否失败
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// 返回成功的数据
    public var value: Request? {
        switch self {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
    }
    
    /// 返回失败的数据
    public var error: APIError? {
        switch self {
        case .success:
            return nil
        case .failure(_, let error):
            return error
        }
    }
}

protocol APIModel: ImmutableMappable, CustomStringConvertible{
}

class APINetworkRequest: APINetworkBaseRequest{
}
