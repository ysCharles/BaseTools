//
//  ImageViewer.swift
//  BaseTools
//
//  Created by Charles on 28/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

/// 屏幕宽度
private var ImageViewerScreenWidth : CGFloat { return UIScreen.main.bounds.width }
/// 屏幕高度
private var ImageViewerScreenHeight : CGFloat { return UIScreen.main.bounds.height }
/// 动画时间
private let ImageViewerAnimationDuriation : TimeInterval =  0.7
/// 背景颜色
private let ImageViewerBackgroundColor =  UIColor.black
/// 底部工具条 高度 适配 iPhone x + 39
let ImageViewBarHeight : CGFloat = ImageViewerScreenHeight == 812 ?  40.0 + 39 : 40.0

public class ImageViewer: NSObject {
    
    /// 单例模式
    public static let shared = ImageViewer()
    
    private var fromRect: CGRect!
    private var currenIndex: NSInteger = 0
    private var imageUrlArray: [ImageResource]!
    private var fromSenderRectArray: [CGRect] = []
    private var isPanRecognize: Bool = false
    
    
    private lazy var backgroundView : UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        return view
    }()
    
    private lazy var beginAnimationView : UIImageView = {
        let imageView = UIImageView(frame : CGRect.zero)
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.backgroundColor = UIColor.clear;
        return imageView
    }()
    
    private lazy var scrollView : UIScrollView = {
        let sView = UIScrollView(frame: UIScreen.main.bounds)
        sView.backgroundColor = UIColor.clear
        sView.isPagingEnabled = true
        sView.alpha = 0.0
        sView.bounces = true
        sView.showsHorizontalScrollIndicator = false
        sView.showsVerticalScrollIndicator = false
        sView.alwaysBounceHorizontal = true
        sView.delegate = self
        return sView
    }()
    
    private lazy var tabBar : ImageViewBar = {
        let view = ImageViewBar(frame: CGRect(x: 0 ,  y: ImageViewerScreenHeight ,  width: ImageViewerScreenWidth, height: ImageViewBarHeight), saveTapClosure: {
            self.saveCurrentImage()
        }, closeTapClosure: {
            self.animationOut()
        })
        
        view.alpha = 0
        return view
    }()
    
    deinit {
        removeOrientationChangeNotification()
    }
}

// MAKR: - 实例方法（showImage）
extension ImageViewer {
    public func show(images : [ImageResource] , at index : NSInteger , from senderArray: [UIView]){
        fromSenderRectArray = []
        
        for i in 0 ... senderArray.count-1 {
            let rect : CGRect = senderArray[i].superview!.convert(senderArray[i].frame, to:UIApplication.shared.keyWindow)
            fromSenderRectArray.append(rect)
        }
        
        currenIndex = index
        imageUrlArray = images
        fromRect = fromSenderRectArray[index]
        
        backgroundView.backgroundColor = ImageViewerBackgroundColor
        UIApplication.shared.keyWindow?.addSubview(backgroundView);
        backgroundView.addSubview(scrollView)
        backgroundView.addSubview(tabBar)
        
        beginAnimationView.isHidden = false
        beginAnimationView.frame = fromRect
        backgroundView.addSubview(beginAnimationView)
        
        if let img : UIImage = (images[index]).image {
            beginAnimationView.image = img
        }else if let imageURL : String = (images[index]).imageURLString {
            beginAnimationView.kf.setImage(with: URL(string: imageURL)!)
        }
        
        UIView.animate(withDuration: ImageViewerAnimationDuriation,
                       animations: { () -> Void in
                        self.beginAnimationView.frame = UIScreen.main.bounds
        }, completion: { (finished) -> Void in
            if (finished == true){
                self.setupView(shouldAnimate: true)
            }
        })
    }
    
    //MARK: - showImages with image url strings
    
    public func show(images : [String] , at index : NSInteger , from senderArray: [UIView]) {
        
        var resources : [ImageResource] = []
        for imageURL in images {
            let resource : ImageResource = ImageResource(image: nil, imageURLString:imageURL)
            resources.append(resource)
        }
        self.show(images: resources, at: index, from: senderArray)
    }
    
}

// MARK: - 静态方法（showImage）
extension ImageViewer {
    //MARK: - showImages with images (supports both images and url strings)
    public static func show(images : [ImageResource] , at index : NSInteger , from senderArray: [UIView]){
        self.shared.show(images: images, at: index, from: senderArray)
    }
    
    //MARK: - showImages with image url strings
    public static func show(images : [String] , at index : NSInteger , from senderArray: [UIView]) {
        self.shared.show(images: images, at: index, from: senderArray)
    }
}

// MARK: - 屏幕方向转变
extension ImageViewer {
    private func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)
        
    }
    
    private func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onChangeStatusBarOrientationNotification(notification : Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.setupView(shouldAnimate: false)
        })
    }
}

// MARK: - UIScrollViewDelegate
extension ImageViewer : UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        currenIndex = NSInteger(scrollView.contentOffset.x / ImageViewerScreenWidth)
        tabBar.countLabel.text = "\(currenIndex+1)/\(imageUrlArray.count)"
    }
}
//MARK: - UIGestureRecognizerDelegate
extension ImageViewer : UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view!.isKind(of: ImageView.self)){
            let translatedPoint = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            return fabs(translatedPoint.y) > fabs(translatedPoint.x);
        }
        return true
    }
}


// MARK: - 私有方法
extension ImageViewer {
    private func setupView(shouldAnimate: Bool){
        backgroundView.frame = UIScreen.main.bounds
        scrollView.frame = UIScreen.main.bounds
        tabBar.frame = CGRect(x: 0 ,  y: ImageViewerScreenHeight ,  width: ImageViewerScreenWidth, height: ImageViewBarHeight)
        
        
        
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        for i in 0 ..< imageUrlArray.count {
            let imageView: ImageView = ImageView(frame: CGRect(x: ImageViewerScreenWidth * CGFloat(i), y: 0, width: ImageViewerScreenWidth, height: ImageViewerScreenHeight), imageResource: imageUrlArray[i], atIndex: i)
            imageView.ImageViewHandleTap = {
                self.animationOut()
            }
            imageView.panGesture.delegate = self;
            imageView.panGesture.addTarget(self, action: #selector(self.panGestureRecognized(_:)))
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imageUrlArray.count), height: UIScreen.main.bounds.height)
        scrollView.scrollRectToVisible(CGRect(x: ImageViewerScreenWidth*CGFloat(currenIndex), y: 0, width: ImageViewerScreenWidth, height: ImageViewerScreenHeight), animated: false)
        tabBar.countLabel.text = "\(currenIndex+1)/\(imageUrlArray.count)"
        
        if shouldAnimate {
            self.show()
        }else{
            self.scrollView.alpha = 1.0
            self.tabBar.alpha = 1
            self.tabBar.frame = CGRect(x: 0, y: ImageViewerScreenHeight - ImageViewBarHeight, width: ImageViewerScreenWidth, height: ImageViewBarHeight)
            self.tabBar.layoutIfNeeded()
        }
    }
    
    private func show() {
        
        self.addOrientationChangeNotification()
        
        UIView.animate(withDuration: ImageViewerAnimationDuriation, animations: { () -> Void in
            self.scrollView.alpha = 1.0
            self.tabBar.alpha = 1
            self.tabBar.frame = CGRect(x: 0, y: ImageViewerScreenHeight - ImageViewBarHeight, width: ImageViewerScreenWidth, height: ImageViewBarHeight)
        }, completion: { (finished: Bool) -> Void in
            self.beginAnimationView.isHidden = true
        })
    }
    
    /// 保存当前图片到相册
    private func saveCurrentImage() {
        var imageToSave : UIImage? = nil
        for img in scrollView.subviews{
            if (img is ImageView) && ((img as! ImageView).tag == currenIndex) {
                if ((img as! ImageView).imageView.image != nil) {
                    imageToSave = (img as! ImageView).imageView.image!
                }
            }
        }
        if imageToSave != nil {
            UIImageWriteToSavedPhotosAlbum(imageToSave!, self, #selector(self.saveImageDone(_:error:context:)), nil)
        }
    }
    
    /// 保存图片回调函数
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - error: 错误
    ///   - context: 上下文环境
    @objc func saveImageDone(_ image : UIImage, error: Error, context: UnsafeMutableRawPointer?) {
        self.tabBar.countLabel.text = NSLocalizedString("Save image done.", comment: "Save image done.")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.tabBar.countLabel.text = "\(self.currenIndex+1)/\(self.imageUrlArray.count)"
        })
    }
    
    //MARK: - animationOut
    /// 动画完毕处理
    fileprivate func animationOut(){
        
        self.removeOrientationChangeNotification()
        
        let page = NSInteger(scrollView.contentOffset.x / ImageViewerScreenWidth)
        
        for img in scrollView.subviews{
            if (img is ImageView) && ((img as! ImageView).tag == page) {
                if ((img as! ImageView).imageView.image != nil) {
                    self.beginAnimationView.image = (img as! ImageView).imageView.image
                    break
                }
            }
        }
        self.beginAnimationView.isHidden = false
        UIView.animate(withDuration: ImageViewerAnimationDuriation, animations: { () -> Void in
            self.beginAnimationView.frame = self.fromSenderRectArray[page]
            self.scrollView.alpha = 0
            self.backgroundView.backgroundColor = UIColor.clear;
            self.tabBar.frame = CGRect(x: 0, y: ImageViewerScreenHeight, width: ImageViewerScreenWidth, height: ImageViewBarHeight)
        }, completion: { (finished: Bool) -> Void in
            if  (finished == true){
                self.beginAnimationView.isHidden = true
                self.scrollView.removeFromSuperview()
                self.tabBar.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
            }
        })
    }
    
    //MARK: - panGestureRecognized
    /// 上推下推手势操作
    ///
    /// - Parameter gesture: 手势
    @objc func panGestureRecognized(_ gesture : UIPanGestureRecognizer){
        let currentItem : UIView = gesture.view!
        let translatedPoint = gesture.translation(in: currentItem)
        let newAlpha = CGFloat(1 - fabsf(Float(translatedPoint.y / ImageViewerScreenHeight)))
        
        if (gesture.state == UIGestureRecognizerState.began || gesture.state == UIGestureRecognizerState.changed){
            scrollView.isScrollEnabled = false
            currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: translatedPoint.y, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
            self.tabBar.frame = CGRect(x: 0, y: ImageViewerScreenHeight - ImageViewBarHeight*newAlpha, width: ImageViewerScreenWidth, height: ImageViewBarHeight)
            backgroundView.backgroundColor = ImageViewerBackgroundColor.withAlphaComponent(newAlpha)
        }else if (gesture.state == UIGestureRecognizerState.ended ){
            
            scrollView.isScrollEnabled = true
            if (fabs(translatedPoint.y) >= ImageViewerScreenHeight*0.2){
                UIView.animate(withDuration: ImageViewerAnimationDuriation, animations: { () -> Void in
                    self.backgroundView.backgroundColor = UIColor.clear
                    if (translatedPoint.y > 0){
                        currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: ImageViewerScreenHeight, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
                    }else{
                        currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: -ImageViewerScreenHeight, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
                    }
                    
                    self.tabBar.frame = CGRect(x: 0, y: ImageViewerScreenHeight, width: ImageViewerScreenWidth, height: ImageViewBarHeight)
                }, completion: { (finished: Bool) -> Void in
                    if  (finished == true){
                        self.removeOrientationChangeNotification()
                        self.scrollView.removeFromSuperview()
                        self.tabBar.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }else{
                UIView.animate(withDuration: ImageViewerAnimationDuriation, animations: { () -> Void in
                    self.backgroundView.backgroundColor = ImageViewerBackgroundColor
                    currentItem.frame = CGRect(x: currentItem.frame.origin.x, y: 0, width: currentItem.frame.size.width, height: currentItem.frame.size.height)
                    self.tabBar.frame = CGRect(x: 0, y: ImageViewerScreenHeight-ImageViewBarHeight, width: ImageViewerScreenWidth, height: ImageViewBarHeight)
                }, completion: { (finished: Bool) -> Void in
                    
                })
            }
        }
    }
}
