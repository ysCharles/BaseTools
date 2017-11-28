//
//  ImageViewerDemoController.swift
//  BaseToolsDemo
//
//  Created by Charles on 28/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import BaseTools

class ImageViewerDemoController: UIViewController {

    @IBOutlet weak var imageGridView: ImageGridView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = [ "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                   "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                   "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                   "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg",
                   "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff6csucjj20gt0aijrh.jpg",
                   "http://ww4.sinaimg.cn/mw600/7352978fgw1f6gkap8p45j20f00f074t.jpg",
                   "http://ww3.sinaimg.cn/mw600/c0679ecagw1f6ff68fzb1j20gt0gtwhf.jpg",
                   "http://ww4.sinaimg.cn/mw600/c0679ecagw1f6ff69na87j20gt08a3z2.jpg",
                   "http://ww1.sinaimg.cn/mw600/c0679ecagw1f6ff6ar7v7j20gt0me3yy.jpg" ]
        
        heightConstraint.constant = ImageGridView.getHeightWithWidth(imageGridView.width, imgCount: data.count)
        
        imageGridView.show(imageArray: data) { (buttonsArray, buttonIndex) in
            ImageViewer.show(images: data, at: buttonIndex, from: buttonsArray)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
