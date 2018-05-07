//
//  APINetworkAgent.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Alamofire代理类
class APINetworkAgent {
    
    /// 单例
    static let shared = APINetworkAgent()
    
    /// SessionManager
    var sessionMnager:APISessionManager = {
        let configuration = URLSessionConfiguration.default
        if let headers = APINetworkConfig.shared().httpHeaders {
            configuration.httpAdditionalHeaders = APISessionManager.defaultHTTPHeaders.merging(headers, uniquingKeysWith: { (_, last) in last })
        }
        configuration.timeoutIntervalForRequest = APINetworkConfig.shared().requestTimeout
        
        let manager = APISessionManager(configuration: configuration)
        return manager
    }()
    
    /// 互斥锁
    fileprivate var mutexLock: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    /// 请求列表
    var requestsRecord: [Int:APINetworkBaseRequest] = [Int:APINetworkBaseRequest]()
    
}

// MARK: - 请求添加和删除
extension APINetworkAgent{
    
    /// 添加请求
    func addRequest(request: APINetworkBaseRequest) {
        
        #if DEBUG //检测是否使用模拟数据
        if APINetworkConfig.shared().isMockData || request.isMockData{
            self.makeMockRequest(request: request)
            return;
        }
        #endif
        
        // 发起真实请求
        request.wrapperRequest = self.makeRequest(request: request)
        self.addRequestToRecord(request)
    }
    
    /// 取消请求
    func cancelRequest(request: APINetworkBaseRequest) {
        request.requestTask?.cancel();
        self.removeRequestFromRecord(request)
        request.clearCallbackBlocks()
    }
    
    /// 取消所有请求
    func cancelAllRequests() {
        let allRequests = self.requestsRecord
        for request:APINetworkBaseRequest in allRequests.values {
            request.stop()
        }
    }
    
    // 添加请求字典里
    func addRequestToRecord(_ request: APINetworkBaseRequest) {
        lock(); defer { unlock() }
        requestsRecord[request.requestTask!.taskIdentifier] = request
        API_print("Request Enqueue, QueueSize = \(requestsRecord.count)")
    }
    
    // 从字典里删除请求
    func removeRequestFromRecord(_ request: APINetworkBaseRequest) {
        lock(); defer { unlock() }
        if let requestTask =  request.requestTask{
            requestsRecord.removeValue(forKey: requestTask.taskIdentifier)
        }
        API_print("Request Dequeue, QueueSize = \(requestsRecord.count)")
    }
}

// MARK: - 构建请求Task
extension APINetworkAgent{
    
    /// 构建真实请求
    func makeRequest(request: APINetworkBaseRequest) -> APIRequest {
        API_print("-----------------------------------------------> 🚀 API发起请求")
        let method:API_HTTPMethod = request.method
        let urlString = String(target: request)
        var requestParams = request.requestParams ?? API_Parameters()
        requestParams[KEY_sign] = API_sign(params: requestParams)
        
        switch method {
        case .post:
            return self.startRequest(request, urlString, method, requestParams, request.httpHeaders)
        default:
            return self.startRequest(request, urlString, method, requestParams, request.httpHeaders)
        }
    }
    
    /// 构建模拟请求
    func makeMockRequest(request: APINetworkBaseRequest) {
        API_print("-----------------------------------------------> 🚧 API发起模拟请求")
        self.handleResponseResult(request, request.mockData, nil)
    }
    
    /// 发起请求
    func startRequest(_ request: APINetworkBaseRequest, _ url: String, _ method: API_HTTPMethod, _ parameters: API_Parameters? = nil, _ headers: API_HTTPHeaders? = nil) -> APIRequest {
        
        // 设置回调异步队列
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        let wrapperRequest = APINetworkAgent.shared.sessionMnager.request(url, method: method, parameters: parameters, headers: headers)
            .responseJSON(queue: utilityQueue) { (response) in
            API_print("-----------------------------------------------> ✈️ API请求回调")
//            API_print("\(response)")
                
            request.wrapperResponse = response
            
            switch response.result {
            case .success(let jsonObject):
                self.handleResponseResult(request, jsonObject as? APIJSONObject, nil)
            case .failure(let error):
                self.handleResponseResult(request, nil, error as NSError)
            }
        }
        return wrapperRequest;
    }
    
    /// 处理请求结果
    func handleResponseResult(_ request: APINetworkBaseRequest, _ responseJsonObject: APIJSONObject?, _ error: NSError?) {
        #if DEBUG
        if APINetworkConfig.shared().isMockData || request.isMockData{
            API_print("\(String(target: request))")
        }
        #else
        API_print("\(request.wrapperRequest as AnyObject)")
        #endif
        
        // 删除请求队列里的request对象
        self.removeRequestFromRecord(request)
        
        //========================== 请求成功 ======================================//
        if let responseJsonObject = responseJsonObject {
            
            let state: APIJSONObject = responseJsonObject[KEY_state] as! APIJSONObject
            request.state = APIState(code: state[KEY_code] as! Int, message: state[KEY_msg] as! String)
            
            if API_HTTP_CODE_SUCCESS == state[KEY_code] as! Int{
                API_print("请求成功 ✅ \(responseJsonObject as AnyObject)")
                
                if let dataObject = responseJsonObject[KEY_data]{
                    request.responseModel = request.mappingModel(jsonObject: dataObject as! APIJSONObject)
                }
                
                DispatchQueue.main.async {
                    // success回调代理
                    request.delegate?.requestSuccess(request)
                    
                    // success回调Block
                    if let callback = request.requestCallback {
                        callback(APIResult.success(request))
                    }
                }
                
                return
            }
        }
        
        //========================== 请求失败 ======================================//
        API_print("请求失败 ❌ \(String(describing: error))")
        
        var apiError: APIError? = nil
        if let requestState = request.state {
            apiError = APIError(code: requestState.code, message: requestState.message)
        }else{
            var message:String?
            if let error = error {
                message = API_handleError(error)
                API_print("请求失败 ❌ \(message!)")
            }
            apiError = APIError(code: API_HTTP_CODE_FAILURE, message: message ?? "请求失败")
        }
        
        DispatchQueue.main.async {
            // failure回调代理
            request.delegate?.requestFailed(request, apiError!)
            
            // failure回调Block
            if let callback = request.requestCallback {
                callback(APIResult.failure(request, apiError!))
            }
        }
        
    }
}

// MARK: - 同步互斥锁
extension APINetworkAgent{
    /// 加锁
    func lock() {
        _ = mutexLock.wait(timeout: DispatchTime.distantFuture)
    }
    
    /// 解锁
    func unlock() {
        mutexLock.signal()
    }
}
