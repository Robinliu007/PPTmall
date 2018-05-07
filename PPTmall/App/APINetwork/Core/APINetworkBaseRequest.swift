//
//  APINetworkBaseRequest.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation

public typealias APIJSONObject = [String:Any]

// MARK: - Block回调

/// 请求回调
typealias API_RequestCallback = (APIResult<APINetworkBaseRequest>) -> Void
/// 成功回调
typealias API_RequestSuccessCallback = (APINetworkBaseRequest) -> Void
/// 失败回调
typealias API_RequestFailedCallback = (APINetworkBaseRequest, APIError) -> Void
/// 上传进度回调
typealias API_UploadProgressCallback = (APINetworkBaseRequest) -> Void
/// 下载进度回调
typealias API_DownloadProgressCallback = (APINetworkBaseRequest) -> Void
/// 上传表单回调
typealias API_MultipartFormDataCallback = (APINetworkBaseRequest) -> Void

// MARK: - 请求回调代理协议

protocol APIRequestDelegate: class{
    /// 请求成功回调
    func requestSuccess(_ request: APINetworkBaseRequest)
    
    /// 请求失败回调
    func requestFailed(_ request: APINetworkBaseRequest, _ error: APIError)
}

// MARK: - 请求定制化协议

protocol APIRequestCustomization {
    var baseURL: String {get}
    var path: String {get}
    var method: API_HTTPMethod {get}
    var httpHeaders: API_HTTPHeaders? {get}
    var requestParams: API_Parameters? {get}
    var isMockData: Bool {get}
    var mockData: APIJSONObject? {get}
    func jsonValidator() -> APIJSONObject?
}

// MARK: - ModelMap

protocol APIModelMap {
    func mappingModel(jsonObject: [String: Any]) -> Any?
}

// MARK: - APIState结构体
public struct APIState {
    var code: Int
    var message: String
}

// MARK: - APIError结构体
public typealias APIError = APIState

// MARK: - 请求基类
class APINetworkBaseRequest: APIRequestCustomization, CustomStringConvertible{
    
    // MARK: - 属性
    
    /// 请求代理对象
    weak var delegate: APIRequestDelegate?
    /// Alamofire的请求对象
    var wrapperRequest: APIRequest?
    /// 响应对象
    var wrapperResponse: APIDataResponse<Any>?
    /// 响应Model数据模型对象
    var responseModel: Any?
    /// 状态对象
    var state: APIState?

    
    // MARK: - Block回调
    
    /// 请求回调Block
    var requestCallback:API_RequestCallback?
    /// 成功回调Block
    var requestSuccessCallback:API_RequestSuccessCallback?
    /// 失败回调Block
    var requestFailedCallback:API_RequestFailedCallback?
    /// 上传进度回调Block
    var uploadProgressCallback:API_UploadProgressCallback?
    /// 下载进度回调Block
    var downloadProgressCallback:API_DownloadProgressCallback?
    /// 上传表单回调Block
    var multipartFormDataCallback:API_MultipartFormDataCallback?
    
    
    // MARK: - 自定义请求协议默认实现
    
    /// 基请求URL
    var baseURL: String {
        return APINetworkConfig.shared().baseURL
    }
    /// 请求URL路径path
    var path: String {
        return ""
    }
    /// HTTP请求类型
    var method: API_HTTPMethod {
        return APINetworkConfig.shared().httpMethod
    }
    /// HTTP头信息
    var httpHeaders: API_HTTPHeaders?{
        return APINetworkConfig.shared().httpHeaders
    }
    /// HTTP请求参数
    var requestParams: API_Parameters?{
        return APINetworkConfig.shared().requestParams
    }
    /// 是否使用模拟数据
    var isMockData: Bool{
        return false
    }
    /// 模拟接口测试数据
    var mockData: APIJSONObject?{
        return nil
    }
    /// 验证数据类型
    func jsonValidator() -> APIJSONObject?{
        return nil
    }
    
    
    // MARK: - 请求行为
    
    /// 发起请求
    func start() {
        APINetworkAgent.shared.addRequest(request: self)
    }
    
    ///  发起请求
    ///
    /// - Parameters:
    ///   - callback: 请求回调
    func start(callback: @escaping API_RequestCallback) {
        self.requestCallback = callback
        self.start()
    }
    
    /// 取消请求
    func stop() {
        APINetworkAgent.shared.cancelRequest(request: self)
    }
    
    /// 清除回调Blocks,防止循环引用
    func clearCallbackBlocks() {
        self.requestCallback = nil
        self.requestSuccessCallback = nil
        self.requestFailedCallback = nil
        self.uploadProgressCallback = nil
        self.downloadProgressCallback = nil
        self.multipartFormDataCallback = nil
    }
    
    /// Json转Model数据模型
    func mappingModel(jsonObject: APIJSONObject) -> Any? {
        return nil
    }
    
    deinit{
        API_print("\(self)")
    }
}

extension APINetworkBaseRequest{
    /// 请求Task
    var requestTask: URLSessionTask?{
        return wrapperRequest?.task
    }
    /// 响应对象
    var response: HTTPURLResponse? {
        return self.requestTask?.response as? HTTPURLResponse
    }
    /// 响应json对象
    var responseJsonObject: APIJSONObject? {
        return self.wrapperResponse?.result.value as? APIJSONObject
    }
    /// 响应状态码
    var responseStatusCode: Int? {
        return self.response?.statusCode
    }
    /// 当前请求对象
    var responseHeaders: [AnyHashable : Any]? {
        return self.response?.allHeaderFields
    }
    /// 当前请求对象
    var currentRequest: URLRequest? {
        return self.requestTask?.currentRequest
    }
    /// 原请求对象
    var originalRequest: URLRequest? {
        return self.requestTask?.originalRequest
    }
    /// 是否已经被取消
    var isCancelled: Bool {
        guard let requestTask = self.requestTask else {
            return false
        }
        return requestTask.state == .canceling
    }
    /// 是否正在执行
    var isExecuting: Bool {
        guard let requestTask = self.requestTask else{
            return false
        }
        return requestTask.state == .running
    }
}
