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

public typealias SuccessClosure = (String) -> Void
public typealias FailureClosure = (String) -> Void


/// 网络请求参数格式 目前支持两种 form表单格式  json格式
///
/// - form: form表单格式
/// - json: json格式
public enum NetparameterType {
    case form
    case json
}

/// 网络请求工具
public class NetUtils: NSObject {
    
    /// 请求统一方法
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - method: 请求方法
    ///   - params: 提交参数
    ///   - success: 成功回调
    ///   - failure: 失败回调
    /// - Returns: request 对应的 key 可用于取消 request 任务
    private func request(urlString: String,
                         method: HTTPMethod,
                         params: [String: Any]?,
                         success: @escaping SuccessClosure,
                         failure:@escaping FailureClosure,
                         parameterType: NetparameterType = .form) -> String {
        // 获取key 并查看 requestTasks 中是否已存在请求任务，如果已存在 取消
        let key = requestTaksKey(url: urlString, params: params)
        if let task = requestTasks[key] {
            task.cancel()
        }
        
        let encoding : ParameterEncoding = parameterType == .form ? URLEncoding.default : JSONEncoding.default
        
        let request = manager.request(urlString, method: method, parameters: params, encoding: encoding, headers: nil)
        //新的请求 加入字典
        requestTasks[key] = request
        
        request.responseString {[unowned self] (response) in
            self.requestTasks.removeValue(forKey: key)
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
//        request.responseJSON {[unowned self] (response) in
//            self.requestTasks.removeValue(forKey: key)
//            switch response.result {
//            case .success(let value):
//                guard let v = value as? [String: Any] else {
//                    failure("返回的数据格式不正确，请确认")
//                    return
//                }
//                success(v)
//            case .failure(let error):
//                failure(error.localizedDescription)
//            }
//        }
        
        return key
    }
    
    /// 多文件上传
    ///
    /// - Parameters:
    ///   - urlString: 上传地址
    ///   - data: 需要提交的数据 包括上传的文件Data和其他字符参数
    ///   - progressClosure: 进度回调闭包
    ///   - success: 成功回调
    ///   - failure: 失败回调
    private func upload(urlString: String,
                data:[String: Any],
                progressClosure: @escaping (Double)->Void,
                success: @escaping SuccessClosure,
                failure:@escaping FailureClosure) {
        manager.upload(multipartFormData: { (multipartFormData) in
            //判断数据字典里的数据类型 Data为上传文件， String 为 普通参数
            if data.count > 0 {
                for (k, v) in data {
                    if v is Data {
                        multipartFormData.append(v as! Data, withName: k)
                    } else if v is String {
                        guard let strData = (v as! String).data(using: .utf8) else {
                            continue
                        }
                        multipartFormData.append( strData, withName: k)
                    } else {
                        proLog("错误的参数格式")
                        failure("请设置正确的参数格式")
                    }
                }
            }
            
        }, to: urlString, encodingCompletion: { (result) in
            switch result {
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress(closure: { (progress) in
                    //这里处理进度问题
                    progressClosure(progress.fractionCompleted)
                }).responseString(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        success(value)
                    case .failure(let error):
                        failure(error.localizedDescription)
                    }
                })
//                    .responseJSON(completionHandler: { (response) in
//                    switch response.result {
//                    case .success(let value):
//                        guard let v = value as? [String: Any] else {
//                            failure("返回的数据格式不正确，请确认")
//                            return
//                        }
//                        success(v)
//                    case .failure(let error):
//                        failure(error.localizedDescription)
//                    }
//                })
            case .failure(let error):
                failure(error.localizedDescription)
            }
        })
    }
    
    // MARK: -
    /// 单例模式
    private static let shared = NetUtils()
    /// 私有化构造函数 保证单例
    private override init() {
        manager = SessionManager.default
    }
    
    /// 请求编码 key
    ///
    /// - Parameters:
    ///   - url: url 地址
    ///   - params: 参数
    /// - Returns: 编码后的 key
    private func requestTaksKey(url: String, params: [String: Any]? = nil) -> String {
        guard let params = params,
            let stringData = try? JSONSerialization.data(withJSONObject: params, options: []),
            let paramString = String(data: stringData, encoding: .utf8) else {
                return url
        }
        let str = "\(url)\(paramString)"
        return str
    }
    
    // MARK:- 私有属性
    private let manager: SessionManager
    private var requestTasks = [String : Request]()
}

// MARK:- 公开方法 （get、 post、设置 request 适配器、upload）
extension NetUtils {
    /// get 网络请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 参数
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    /// - Returns: request 对应的 key 可用于取消 request 任务
    @discardableResult
    public static func getRequest(urlString: String,
                                  params: [String: Any]?,
                                  success: @escaping SuccessClosure,
                                  failure:@escaping FailureClosure,
                                  parameterType: NetparameterType = .form) -> String {
        return shared.request(urlString: urlString, method: .get, params: params, success: success, failure: failure, parameterType: parameterType)
    }
    
    /// post 网络请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 参数
    ///   - success: 请求陈宫回调
    ///   - failure: 请求失败回调
    /// - Returns: request 对应的 key 可用于取消 request 任务
    @discardableResult
    public  static func postRequest(urlString: String,
                                    params: [String: Any]?,
                                    success: @escaping SuccessClosure,
                                    failure:@escaping FailureClosure,
                                    parameterType: NetparameterType = .form) -> String {
        return shared.request(urlString: urlString, method: .post, params: params, success: success, failure: failure, parameterType: parameterType)
    }
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - urlString: 上传地址
    ///   - image: 图片
    ///   - progress: 进度回调
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public static func upload(urlString: String,
                              image: UIImage,
                              progress: @escaping (Double)->Void,
                              success: @escaping SuccessClosure,
                              failure: @escaping FailureClosure) {
        // 压缩文件
        guard let imgData = image.zip2Data() else {
            failure("")
            return
        }
        shared.upload(urlString: urlString, data: ["image": imgData], progressClosure: progress, success: success, failure: failure)
    }
    
    /// 取消网络请求
    ///
    /// - Parameter key: 网络请求对应的 key
    public static func cancelRequest(forKey key: String) {
        if let task = shared.requestTasks[key] {
            task.cancel()
            shared.requestTasks.removeValue(forKey: key)
        }
    }
    
    
    /// 设置 RequestAdapter 通产用于给 request 设置 heaher
    ///
    /// - Parameter adapter: 适配器
    public static func setAdapter(adapter: RequestAdapter) {
        shared.manager.adapter = adapter
    }
}

// MARK:- request适配器
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


