//
//  APINetworkConfig.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation

// MARK: - API环境配置
//==========================================================================//

// 设置当前API环境
#if DEBUG
let API_Env: APIEnv = .API_PROD
#else
let API_Env: APIEnv = .API_PROD
#endif

// API接口签名参数
let API_SignKey = "JC8rq$w66TP!oZOfJs3m"

// API环境配置
enum APIEnv: Int{
    case API_DEV = 0 // 开发环境
    case API_QA      // 测试环境
    case API_PROD    // 线上环境
    
    var urls: [String:String] {
        switch self {
        case .API_DEV:
            return [
                API_KEY_baseURL: "http://192.168.150.37:8005/index.php?"
            ]
        case .API_QA:
            return [
                API_KEY_baseURL: "http://115.159.252.254/index.php?"
            ]
        default: // 默认线上环境
            return [
                API_KEY_baseURL: "https://ngc.ztgame.com/index.php?"
            ]
        }
    }
}

// MARK: - API配置类
//==========================================================================//

class APINetworkConfig: CustomStringConvertible{
    
    // MARK: - Singleton
    private static let sharedManager: APINetworkConfig = {
        let shared = APINetworkConfig()
        return shared
    }()

    /// 单例
    class func shared() -> APINetworkConfig {
        return sharedManager
    }

    // MARK: - Properties
    
    /// 是否打印Log输出
    #if DEBUG
    static var debugEnable: Bool = true
    #else
    static var debugEnable: Bool = false
    #endif
    
    /// 默认基请求URL
    let baseURL: String = API_Env.urls[API_KEY_baseURL]!
    
    /// 默认请求方法
    let httpMethod: API_HTTPMethod = API_HTTPMethod.get
    
    /// 默认请求头
    let httpHeaders: API_HTTPHeaders? = ["ver": "1.2.5"];
    
    /// 默认请求参数
    let requestParams: API_Parameters? = nil
    
    /// 请求超时时间
    let requestTimeout: TimeInterval = 5.0
    
    /// 是否使用模拟数据, 默认不使用
    let isMockData = false
}

// MARK: - 常量
//==========================================================================//

//基础访问地址
let API_KEY_baseURL = "baseURL"

//自定义响应状态码
let API_HTTP_CODE_SUCCESS = 0; //0:成功，非0:失败
let API_HTTP_CODE_FAILURE = 1; //操作失败
let API_HTTP_CODE_1005    = 1005; //会话失效，请重新初始化会话

// 标准响应状态码
let API_HTTP_CODE_200                    = 200;
let API_HTTP_CODE_OK                     = 200;
let API_HTTP_CODE_CREATED                = 201;
let API_HTTP_CODE_NO_CONTENT             = 204;

let API_HTTP_CODE_400                    = 400;
let API_HTTP_CODE_UNAUTHORIZED           = 401;
let API_HTTP_CODE_FORBIZTDDEN            = 403;
let API_HTTP_CODE_METHOD_NOT_ALLOWED     = 405;
let API_HTTP_CODE_NOT_ACCEPTABLE         = 406;
let API_HTTP_CODE_UNSUPPORTED_MEDIA_TYPE = 415;
let API_HTTP_CODE_UNPROCESSABLE_ENTITY   = 422;

let API_HTTP_CODE_500                    = 500;
let API_HTTP_CODE_SERVER_ERROR           = 500;
