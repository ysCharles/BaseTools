//
//  WebImageExtension.swift
//  BaseTools
//
//  Created by Charles on 24/10/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - 图片控件网络加载扩展（缓存 异步）
extension UIImageView {
    /// 设置加载网络图片
    ///
    /// - Parameters:
    ///   - urlString: 网络图片地址
    ///   - placeHolder: 占位图
    public func setWebImage(urlString: String, placeHolder: UIImage? = nil) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: urlString) , placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: { (completed, total) in
            proLog("进度：\(completed)/\(total)")
        }) { (image, error, type, url) in
            proLog("\(urlString) --> finished")
        }
    }
}

// MARK: - 按钮控件网络加载扩展（缓存 异步）
extension UIButton {
    /// 设置加载网络图片
    ///
    /// - Parameters:
    ///   - urlString: 网络图片地址
    ///   - state: UIControlState
    ///   - placeHolder: 占位图
    public func setWebImage(urlString: String, for state: UIControlState, placeHolder: UIImage? = nil) {
        self.kf.setImage(with: URL(string: urlString), for: state, placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: { (completed, total) in
            proLog("进度：\(completed)/\(total)")
        }) { (image, error, type, url) in
            proLog("\(urlString) --> finished")
        }
    }
    
    /// 设置加载网络图片
    ///
    /// - Parameters:
    ///   - urlString: 网络图片地址
    ///   - state: UIControlState
    ///   - placeHolder: 占位图
    public func setBackgroundWebImage(urlString: String, for state: UIControlState, placeHolder: UIImage? = nil) {
        self.kf.setBackgroundImage(with: URL(string: urlString), for: state, placeholder: placeHolder, options: [.transition(.fade(1))], progressBlock: { (completed, total) in
            proLog("进度：\(completed)/\(total)")
        }) { (image, error, type, url) in
            proLog("\(urlString) --> finished")
        }
    }
}

/// 清除所有图片缓存 这里只清除通过 Kingfisher 的缓存
public func clearImageCache() {
    let cache = KingfisherManager.shared.cache
    cache.clearMemoryCache()
    cache.clearDiskCache()
    cache.cleanExpiredDiskCache()
}


