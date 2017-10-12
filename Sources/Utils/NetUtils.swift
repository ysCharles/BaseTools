//
//  NetUtils.swift
//  BaseTools
//
//  Created by Charles on 22/09/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import Foundation
import Alamofire
import WebKit

/// 网络请求工具
public class NetUtils: NSObject {
    
    private func request(urlString: String,
                         method: HTTPMethod,
                         params: [String: Any]?,
                         success: @escaping ([String: Any])->(),
                         failure:@escaping (String)->()) {
        let request = manager.request(urlString, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let v = value as? [String: Any] else {
                    failure("返回的数据格式不正确，请确认")
                    return
                }
                success(v)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    // MARK: -
    /// 单例模式
    private static let shared = NetUtils()
    /// 私有化构造函数 保证单例
    private override init() {
        manager = SessionManager.default
    }
    
    // MARK:- 私有属性
    private let manager: SessionManager
    private var requestDic = [String : Request]()
}

extension NetUtils {
    /// get 网络请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 参数
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    public static func getRequest(urlString: String,
                                  params: [String: Any]?,
                                  success: @escaping ([String: Any])->(),
                                  failure:@escaping (String)->()) {
        shared.request(urlString: urlString, method: .get, params: params, success: success, failure: failure)
    }
    
    /// post 网络请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 参数
    ///   - success: 请求陈宫回调
    ///   - failure: 请求失败回调
    public  static func postRequest(urlString: String,
                                    params: [String: Any]?,
                                    success: @escaping ([String: Any])->Void,
                                    failure:@escaping (String)->Void) {
        shared.request(urlString: urlString, method: .post, params: params, success: success, failure: failure)
    }
    
    /// 设置 RequestAdapter 通产用于给 request 设置 heaher
    ///
    /// - Parameter adapter: 适配器
    public static func setAdapter(adapter: RequestAdapter) {
        shared.manager.adapter = adapter
    }
}

/// 给 request 添加 header
public class RequestHeaderAdapter: RequestAdapter {
    
    private var headers: [String: String]
    
    public init(headers: [String: String]) {
        self.headers = headers
    }
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        //这里可以判断 request 确定哪些 request 需要加 header
        if headers.count > 0 {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return urlRequest
    }
}


