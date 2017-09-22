//
//  NetUtils.swift
//  BaseTools
//
//  Created by Charles on 22/09/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import Foundation
import Alamofire

/// 网络请求工具
public class NetUtils: NSObject {
    
    // MARK: -
    /// 单例模式
    private static let shared = NetUtils()
    /// 私有化构造函数 保证单例
    private override init() {
        
    }
}

