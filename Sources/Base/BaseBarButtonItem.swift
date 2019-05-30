//
//  BaseBarButtonItem.swift
//  BaseProject
//
//  Created by Charles on 06/03/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

///
public class BaseBarButtonItem: UIBarButtonItem {
    
    /// 根据图片生成一个barbuttonitem
    ///
    /// - Parameters:
    ///   - image: 普通状态下的图片
    ///   - selectedImage: 选中状态下的图片 如果传 nil 则用普通状态下的图片
    ///   - offset: 偏移量
    ///   - target: 点击操作绑定对象
    ///   - action: 操作方法
    /// - Returns: barbuttonitem
    public static func item(image: UIImage, selectedImage: UIImage?, offset: CGFloat, target: Any?, action: Selector) -> BaseBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: offset, y: 0, width: 44, height: 44)
        btn .addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(image, for: .normal)
        btn.setImage(selectedImage ?? image, for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: offset, bottom: 5, right: 0)
        let item = BaseBarButtonItem(customView: btn);
        return item
    }
    
    /// 根据标题生成一个 barbuttonitem
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - offset: 偏移量
    ///   - target: 点击操作绑定对象
    ///   - action: 操作方法
    /// - Returns: barbuttonitem
    public static func item(title: String, titleColor: UIColor, offset: CGFloat, target:Any?, action: Selector) -> BaseBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        
        let nsStr = title as NSString
        let frame = nsStr.boundingRect(with: CGSize(width:150,height:20), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let minWidth = frame.size.width + 30.0
        btn.frame = CGRect(x: offset, y: 0, width: minWidth, height: 44)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
        return BaseBarButtonItem(customView: btn)
    }
}
