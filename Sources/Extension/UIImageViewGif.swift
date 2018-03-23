//
//  UIImageViewGif.swift
//  BaseTools
//
//  Created by Charles on 23/03/2018.
//  Copyright © 2018 Charles. All rights reserved.
//

import UIKit

extension UIImageView {
    public func loadGif(name: String, bundle: Bundle?) {
        let bd = bundle ?? Bundle.main
        
        guard let path = bd.path(forResource: name, ofType: nil),
            let data = NSData(contentsOfFile: path),
            let imageSource = CGImageSourceCreateWithData(data, nil) else {
                return
        }
        
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        
        for i in 0 ..< CGImageSourceGetCount(imageSource) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                continue
            }
            
            let img = UIImage(cgImage: cgImage)
            i == 0 ? self.image = img : ()
            images.append(img)
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? Dictionary<CFString, Any>,
                let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary,
                let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {
                    continue
            }
            totalDuration = totalDuration + frameDuration.doubleValue
        }
        
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 0
        
        self.startAnimating()
    }
}
