//
//  UIImageExtension.swift
//  BaseTools
//
//  Created by Charles on 11/10/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit


/// UIImage 压缩扩展
typealias UIImageScale = UIImage
extension UIImageScale {
    /// 图片压缩为 Data
    ///
    /// - Parameter maxSize: 压缩后的大小上限 默认100K
    /// - Returns: 压缩后的 Data 可用于上传
    public func zip2Data(maxSize: CGFloat = 100 * 1024) -> Data? {
        var compression = CGFloat(0.85) //压缩比
        guard let tempData = UIImageJPEGRepresentation(self, compression) else { return nil }
        
        var compressedData = tempData
        
        var lastSize = 0 //记录上一次的大小，如果
        while CGFloat(compressedData.count) > maxSize {
            compression = compression * 0.85
            guard let tmpData = UIImageJPEGRepresentation(self, compression) else { return nil }
            // 判断和上次压缩后的大小比  如果一样 说明图片不能再压缩 就此返回
            if lastSize == tmpData.count {
                return tmpData
            }
            lastSize = tmpData.count
            
            compressedData = tmpData
        }
        
        return compressedData
    }
    
    /// 等比缩放本图片大小
    ///
    /// - Parameter width: 缩放后图片宽度，像素为单位
    /// - Returns: 压缩后的 UIImage
    public func scale(withWidth width: CGFloat) -> UIImage? {
        let imageWidth = self.size.width
        let imageHeight = self.size.height
        
        let newWidth = width
        let newHeight = imageHeight / (imageWidth / newWidth)
        
        let widthScale = imageWidth / newWidth
        let heightScale = imageHeight / newHeight
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        if widthScale > heightScale {
            self.draw(in: CGRect(x: 0, y: 0, width: imageWidth / heightScale, height: newHeight))
        } else {
            self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: imageHeight / widthScale))
        }
        
        // 从当前context中创建一个改变大小后的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 使当前的context出堆栈
        UIGraphicsEndImageContext()
        return newImage
    }
}

