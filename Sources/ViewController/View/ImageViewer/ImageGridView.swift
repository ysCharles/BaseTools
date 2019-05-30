//
//  ImageGridView.swift
//  BaseTools
//
//  Created by Charles on 28/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

private let ImageGridViewImageMargin : CGFloat = 2.0
private let KCOLOR_BACKGROUND_WHITE = UIColor(red:241/255.0, green:241/255.0, blue:241/255.0, alpha:1.0)

/// 九宫格展示控件
public class ImageGridView: UIView {
    var imageGridViewTapClosure : ((_ buttonArray: [UIButton] , _ buttonIndex : NSInteger) ->())?
    var buttonArray : [UIButton] = []
    
    //MARK: - internal init frame imageArray tapBlock
    public convenience init(frame : CGRect, imageArray : [String] , tapClosure : @escaping ((_ buttonsArray: [UIButton] , _ buttonIndex : NSInteger) ->())){
        self.init(frame: frame)
        
        self.show(imageArray: imageArray, tapClosure: tapClosure)
    }
    
    //MARK: - onClickImage
    @objc func onClickImage(_ sender: UIButton){
        imageGridViewTapClosure?(self.buttonArray, sender.tag)
    }

}

extension ImageGridView {
    // MARK: - get Height With Width
    /// 根据控件宽度获取控件高度
    ///
    /// - Parameters:
    ///   - width: 控件宽度
    ///   - imgCount: 图片个数
    /// - Returns: 控件高度
    public class func getHeightWithWidth(_ width: CGFloat, imgCount: Int) -> CGFloat{
        if imgCount == 1 {
            return width * 0.5
        }
        
        let imgHeight: CGFloat = (width - ImageGridViewImageMargin * 2) / 3
        let photoAlbumHeight : CGFloat = imgHeight * CGFloat(ceilf(Float(imgCount) / 3)) + ImageGridViewImageMargin * CGFloat(ceilf(Float(imgCount) / 3)-1)
        return photoAlbumHeight
    }
    
    /// 展示图片
    ///
    /// - Parameters:
    ///   - imageArray: 图片链接数组
    ///   - tapBlock: 点击单个图片处理闭包
    public func show(imageArray : [String] , tapClosure : @escaping ((_ buttonsArray: [UIButton] , _ buttonIndex : NSInteger) ->())) {
        
        buttonArray = []
        
        for views in self.subviews {
            if views.isKind(of: UIButton.classForCoder()){
                views.removeFromSuperview();
            }
        }
        
        if imageArray.count > 0 {
            imageGridViewTapClosure = tapClosure
            let imgHeight : CGFloat = (frame.size.width - ImageGridViewImageMargin * 2) / 3
            
            if imageArray.count == 1 {
                let imageButton  = UIButton()
                imageButton.frame = CGRect(x: ImageGridViewImageMargin, y: ImageGridViewImageMargin, width: frame.size.width - 2 * ImageGridViewImageMargin, height: frame.size.height - 2 * ImageGridViewImageMargin)
                imageButton.backgroundColor = KCOLOR_BACKGROUND_WHITE
                imageButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                imageButton.kf.setImage(with: URL(string: imageArray[0])!, for: UIControl.State.normal)
                
                imageButton.tag = 0
                imageButton.clipsToBounds = true
                imageButton.addTarget(self, action: #selector(ImageGridView.onClickImage(_:)), for: UIControl.Event.touchUpInside)
                self.addSubview(imageButton)
                
                self.buttonArray.append(imageButton)
            } else {
                let imgCount = imageArray.count == 4 ? 2 : 3
                
                for i in 0 ... imageArray.count-1 {
                    let x = CGFloat(i % imgCount) * (imgHeight + ImageGridViewImageMargin)
                    let y = CGFloat(i / imgCount) * (imgHeight + ImageGridViewImageMargin)
                    let imageButton  = UIButton()
                    imageButton.frame = CGRect(x: x, y: y, width: imgHeight, height: imgHeight)
                    imageButton.backgroundColor = KCOLOR_BACKGROUND_WHITE
                    imageButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                    imageButton.kf.setImage(with: URL(string: imageArray[i])!, for: UIControl.State.normal)
                    
                    imageButton.tag = i
                    imageButton.clipsToBounds = true
                    imageButton.addTarget(self, action: #selector(ImageGridView.onClickImage(_:)), for: UIControl.Event.touchUpInside)
                    self.addSubview(imageButton)
                    
                    self.buttonArray.append(imageButton)
                }
            }
        }
    }
}
