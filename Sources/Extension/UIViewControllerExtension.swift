//
//  UIViewControllerExtension.swift
//  BaseTools
//
//  Created by Charles on 16/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import MBProgressHUD

public class HUDManager {
    public static let shared = HUDManager()
    
    var hud : MBProgressHUD?
    
    private init() {
        
    }
    
    /// 设置弹窗
    ///
    /// - Parameters:
    ///   - superView: 弹窗的承载控件
    ///   - yOffset: 默认为中心，正数为向下便偏移  负数为向上偏移
    static func setupHUD(superView: UIView?, yOffset: CGFloat? = 0) {
        hideHUD()
        
        guard let sView = superView ?? UIApplication.shared.keyWindow else {
            return
        }
        
        let HUD = MBProgressHUD(view: sView)
        
        HUD.label.font = UIFont.systemFont(ofSize:15)
        //设为false后点击屏幕其他地方有反应
        HUD.isUserInteractionEnabled = false
        //HUD内的内容的颜色
        HUD.contentColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
        //View的颜色
        HUD.bezelView.color = UIColor.color(hexString: "0x000000", alpha: 0.7)
        //style -blur 不透明 －solidColor 透明
        HUD.bezelView.style = .solidColor
        HUD.margin = 12
        // 隐藏时从父控件删除
        HUD.removeFromSuperViewOnHide = true
        
        //偏移量，以 center 为起点
        HUD.offset.y = yOffset ?? 0
        sView.addSubview(HUD)
        HUDManager.shared.hud = HUD
        
    }
    
    public static func hideHUD() {
        if let hud = HUDManager.shared.hud {
            hud.hide(animated: true)
        }
    }
    
    //
    public static func showText(msg: String = "加载中", duration: Double? = nil, superView: UIView? = nil) {
        setupHUD(superView: superView)
        
        let hud = HUDManager.shared.hud
        hud?.mode = .text
        hud?.label.text = msg
        hud?.show(animated: true)
        if let duration = duration {
            hud?.hide(animated: true, afterDelay: duration)
        }
    }
    
    public static func showGifImage(name: String, msg: String, duration: Double? = nil, superView: UIView? = nil, bundle: Bundle? = nil) {
        setupHUD(superView: superView)
        
        let hud = HUDManager.shared.hud
        hud?.mode = .customView
        
        let imageView = UIImageView()
        imageView.loadGif(name: name, bundle: bundle)
        hud?.customView = imageView
        hud?.label.text = msg
        hud?.show(animated: true)
        if let duration = duration {
            hud?.hide(animated: true, afterDelay: duration)
        }
    }
    
}

extension UIViewController {
    
    public func showTextHud(msg: String = "加载中", duration: Double? = nil) {
        HUDManager.showText(msg: msg, duration: duration, superView: self.view)
    }
    
    /// 移除
    public func hideHud() {
        HUDManager.hideHUD()
    }
}
