//
//  APINetworkUtils.swift
//  AlamofireAPI
//
//  Created by robin on 2018/4/13.
//  Copyright © 2018年 robin.com. All rights reserved.
//

import Foundation
import CryptoSwift

let APILoggerTag = "[APILog]"

// MARK: - API接口签名
func API_sign(params: APIJSONObject)->String {
    let sortedParamsKeys = params.keys.filter { (value) -> Bool in
        return value != "sign"
        }.sorted()
    
    var paramStr:String = ""
    for k in sortedParamsKeys {
        if let value = params[k] {
            if paramStr == "" {
                paramStr = String(describing: value).md5()
            } else {
                paramStr += String(describing: value).md5()
            }
        }
    }
    let checkStr:String = paramStr + API_SignKey
    return checkStr.md5()
}

// MARK: - 自定义日志输出
func API_print(file: String = #file,
            method: String = #function,
            line: Int = #line) {
    #if DEBUG
    if APINetworkConfig.debugEnable {
        print("\(Date()) \(APILoggerTag) [\((file as NSString).lastPathComponent):\(line)] \(method): ")
    }
    #endif
}

func API_print<T>(_ message: T,
               file: String = #file,
               method: String = #function,
               line: Int = #line) {
    #if DEBUG
    if APINetworkConfig.debugEnable {
        print("\(Date()) \(APILoggerTag) [\((file as NSString).lastPathComponent):\(line)] \(method): \(message)")
    }
    #endif
}

// MARK: - 打印对象内存地址
extension String {
    static func API_pointer(_ object: AnyObject?) -> String {
        guard let object = object else { return "nil" }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: opaque)
    }
}

// 其它打印对象内存地址
//print("object memory address 111 \(ObjectIdentifier(self))")
//print("object memory address 222 \(String(format: "%p", self))")
//print("object memory address 333 \(String.pointer(self))")

// MARK: - 打印对象信息
extension CustomStringConvertible {
    var description : String {
        var description: String = "***** \(type(of: self)) - <\(String.API_pointer(self as AnyObject))> ***** \n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(Date()) \(APILoggerTag) ------> \(propertyName): \(child.value)\n"
            }
        }
        return description
    }
}

// MARK: - Extension
extension String {
    init<T: APINetworkBaseRequest>(target: T) {
        if target.path.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL+target.path
        }
    }
}

// MARK: - Error
func API_handleError(_ error: NSError) -> String{
    
    var message = ""
    
    if error.domain == NSURLErrorDomain{
        switch (error.domain, error.code) {
        case (NSURLErrorDomain, NSURLErrorCancelled):
            message = "请求被取消!"
            
        case (NSURLErrorDomain, NSURLErrorTimedOut):
            message = "请求超时，请稍后再试!"
            
        case (NSURLErrorDomain, NSURLErrorCannotFindHost),
             (NSURLErrorDomain, NSURLErrorCannotConnectToHost),
             (NSURLErrorDomain, NSURLErrorNotConnectedToInternet):
            message = "当前网络不可用!"
            
        case (NSURLErrorDomain, NSURLErrorNetworkConnectionLost),
             (NSURLErrorDomain, NSURLErrorHTTPTooManyRedirects),
             (NSURLErrorDomain, NSURLErrorSecureConnectionFailed),
             (NSURLErrorDomain, NSURLErrorDNSLookupFailed):
            message = "当前网络状态不稳定，请稍后再试!"
            
        case (NSURLErrorDomain, NSURLErrorServerCertificateHasBadDate),
             (NSURLErrorDomain, NSURLErrorServerCertificateUntrusted),
             (NSURLErrorDomain, NSURLErrorServerCertificateHasUnknownRoot),
             (NSURLErrorDomain, NSURLErrorClientCertificateRejected),
             (NSURLErrorDomain, NSURLErrorClientCertificateRequired),
             (NSURLErrorDomain, NSURLErrorCannotLoadFromNetwork),
             (NSURLErrorDomain, NSURLErrorServerCertificateNotYetValid):
            message = "请求认证异常，请稍后再试!"
            
        case (NSURLErrorDomain, NSURLErrorBadServerResponse),
             (NSURLErrorDomain, NSURLErrorCannotDecodeRawData),
             (NSURLErrorDomain, NSURLErrorCannotDecodeContentData),
             (NSURLErrorDomain, NSURLErrorCannotParseResponse):
            message = "服务器过载，请稍后再试!"
            
        default:
            message = "请求异常，请稍后再试!"
        }
    }
    
    return message
}
