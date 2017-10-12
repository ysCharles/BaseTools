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
    public static func getRequest(urlString: String, params: [String: Any]?) {
        let request = shared.manager.request(urlString, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
        request.responseString { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print("error: \(error)")
            }
        }
        request.responseJSON { (response) in
            switch response.result {
            case .success(let  value):
                if value is Dictionary<String, Any> {
                    print("Dictionary")
                }
                print(value)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}

/// 给 request 添加 header
public class RequestHeaderAdapter: RequestAdapter {
    
    private var headers: [String: String]
    
    init(headers: [String: String]) {
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


