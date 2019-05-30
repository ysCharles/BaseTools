//
//  ImageView.swift
//  BaseTools
//
//  Created by Charles on 28/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

private let tabBarHeight : CGFloat = UIScreen.main.bounds.height == 812 ?  40.0 + 39 : 40

class ImageView: UIScrollView {
    var imageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    var ImageViewHandleTap: (() -> ())?
    var singleTap : UITapGestureRecognizer!
    var doubleTap : UITapGestureRecognizer!
    var panGesture : UIPanGestureRecognizer!
    
    
    //MARK: -
    public init(frame : CGRect, imageResource : ImageResource, atIndex : NSInteger){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.0
        self.delegate = self
        self.tag = atIndex
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (frame.width - tabBarHeight)/2, y: (frame.height - tabBarHeight)/2, width: tabBarHeight, height: tabBarHeight))
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        if let img : UIImage = imageResource.image {
            imageView.image = img
        }else if let imageURL : String = imageResource.imageURLString {
            imageView.kf.setImage(with: URL(string: imageURL)!,
                                  placeholder: nil,
                                  options: nil,
                                  progressBlock: { (done, total) in
                                    
            }) { (image, error, cashType, url) in
                if image != nil && error == nil {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        self.addSubview(imageView)
        
        self.setupGestures()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupGestures() {
        //gesture
        singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delaysTouchesBegan = true
        self.addGestureRecognizer(singleTap)
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
        panGesture = UIPanGestureRecognizer()
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
    }
}


// MARK: - UIScrollViewDelegate
extension ImageView : UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?{
        return imageView
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat){
        let ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right
        let hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let w = imageView.frame.size.width
        let h = imageView.frame.size.height
        var rct = imageView.frame
        rct.origin.x = (ws > w) ? (ws-w)/2 : 0
        rct.origin.y = (hs > h) ? (hs-h)/2 : 0
        imageView.frame = rct;
    }
}

extension ImageView {
    //MARK: - handleSingleTap
    @objc func handleSingleTap(_ sender: UITapGestureRecognizer){
        self.ImageViewHandleTap?()
    }
    
    //MARK: - handleDoubleTap
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: self)
        if (self.zoomScale == self.maximumZoomScale){
            self.setZoomScale(self.minimumZoomScale, animated: true)
        }else{
            self.zoom(to: CGRect(x: touchPoint.x, y: touchPoint.y, width: 1, height: 1), animated: true)
        }
    }
}
