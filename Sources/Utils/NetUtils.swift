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
    
    /// 请求统一方法
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - method: 请求方法
    ///   - params: 提交参数
    ///   - success: 成功回调
    ///   - failure: 失败回调
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
                success: @escaping ([String: Any])->(),
                failure:@escaping (String)->()) {
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
                }).responseJSON(completionHandler: { (response) in
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
                })
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
    
    // MARK:- 私有属性
    private let manager: SessionManager
    private var requestDic = [String : Request]()
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
                              success: @escaping ([String: Any])->Void,
                              failure: @escaping (String)-> Void) {
        // 压缩文件
        guard let imgData = image.zip2Data() else {
            failure("")
            return
        }
        shared.upload(urlString: urlString, data: ["image": imgData], progressClosure: progress, success: success, failure: failure)
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


