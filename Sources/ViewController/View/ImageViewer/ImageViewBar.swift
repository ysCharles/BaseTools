//
//  ImageViewBar.swift
//  BaseTools
//
//  Created by Charles on 28/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

/// 默认边距
private let ImageViewBarDefaultMargin : CGFloat = 5
/// 按钮宽度
private let ImageViewBarButtonWidth : CGFloat =  30.0
/// 工具条背景色
private let ImageViewBarBackgroundColor =  UIColor.black.withAlphaComponent(0.3)

/// 图片浏览器底部工具条
class ImageViewBar: UIView {
    var saveButtonTapClosure : (() -> Void)!
    var closeButtonTapClosure : (() -> Void)!
    
    /// 关闭按钮
    fileprivate lazy var closeButton : UIButton = {
        let button = UIButton(frame: CGRect(x: ImageViewBarDefaultMargin, y: (self.frame.height-ImageViewBarButtonWidth)/2, width: ImageViewBarButtonWidth, height: ImageViewBarButtonWidth))
        button.backgroundColor = UIColor.clear
        button.contentMode = UIViewContentMode.scaleAspectFill
        button.addTarget(self, action: #selector(ImageViewBar.onCloseButtonTapped), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    /// 保存按钮
    fileprivate lazy var saveButton : UIButton = {
        let button = UIButton(frame: CGRect(x: self.frame.width-ImageViewBarButtonWidth-ImageViewBarDefaultMargin, y: (self.frame.height-ImageViewBarButtonWidth)/2, width: ImageViewBarButtonWidth, height: ImageViewBarButtonWidth))
        button.backgroundColor = UIColor.clear
        button.contentMode = UIViewContentMode.scaleAspectFill
        button.addTarget(self, action: #selector(ImageViewBar.onSaveButtonTapped), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    /// 计数标签
    lazy var countLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: ImageViewBarButtonWidth+ImageViewBarDefaultMargin*2, y: 0, width: self.frame.width-(ImageViewBarButtonWidth+ImageViewBarDefaultMargin*2)*2, height: self.frame.height))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.text = "-/-"
        return label
    }()
    
    // MARK: - convenience init
    public convenience init(frame: CGRect , saveTapClosure: @escaping ()->() , closeTapClosure: @escaping ()->()) {
        self.init(frame: frame)
        self.backgroundColor = ImageViewBarBackgroundColor
        
        saveButtonTapClosure = saveTapClosure
        closeButtonTapClosure = closeTapClosure
        
        closeButton.setImage(UIImage(named: "close", in: Bundle(for: self.classForCoder), compatibleWith: nil), for: UIControlState())
        self.addSubview(closeButton)
        
        saveButton.setImage(UIImage(named: "save", in: Bundle(for: self.classForCoder), compatibleWith: nil), for: UIControlState())
        self.addSubview(saveButton)
        
        self.addSubview(countLabel)
    }
    
    // MARK: - onCloseButtonTapped
    @objc func onCloseButtonTapped(){
        self.closeButtonTapClosure()
    }
    
    // MARK: - onSaveButtonTapped
    @objc func onSaveButtonTapped(){
        self.saveButtonTapClosure()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        self.closeButton.frame = CGRect(x: ImageViewBarDefaultMargin, y: (self.frame.height-ImageViewBarButtonWidth)/2, width: ImageViewBarButtonWidth, height: ImageViewBarButtonWidth)
        self.saveButton.frame = CGRect(x: self.frame.width-ImageViewBarButtonWidth-ImageViewBarDefaultMargin, y: (self.frame.height-ImageViewBarButtonWidth)/2, width: ImageViewBarButtonWidth, height: ImageViewBarButtonWidth)
        self.countLabel.frame = CGRect(x: ImageViewBarButtonWidth + ImageViewBarDefaultMargin*2, y: 0, width: self.frame.width-(ImageViewBarButtonWidth + ImageViewBarDefaultMargin*2)*2, height: self.frame.height)
    }
}
