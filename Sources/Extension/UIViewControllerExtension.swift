//
//  UIViewControllerExtension.swift
//  BaseTools
//
//  Created by Charles on 16/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    public func showTextHud(in sView: UIView? = nil, msg: String = "加载中", duration: Double? = nil, yOffset: CGFloat? = 0) {
        setupHUD(superView: sView ?? (self.view)!)
        hud?.mode = .text
        hud?.label.text = msg
        hud?.show(animated: true)
        if let duration = duration {
            hud?.hide(animated: true, afterDelay: duration)
        }
    }
    
    public func showNetLoadingHud(in sView: UIView? = nil, msg: String = "加载中...") {
        setupHUD(superView: sView ?? (self.view)!)
        hud?.label.text = msg
        hud?.show(animated: true)
    }
    
    /// 移除
    public func hideHud() {
        if let hud = hud {
            hud.hide(animated: true)
        }
    }
    
    private func setupHUD(superView: UIView, yOffset: CGFloat? = 0) {
        hideHud()
        
        let HUD = MBProgressHUD(view: superView)
//        HUD.mode = .text
//        HUD.label.text = msg
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
        superView.addSubview(HUD)
        hud = HUD
    }
    
    // MARK: - 给 UIViewController 添加hud属性
    /// hud 属性
    var hud: MBProgressHUD? {
        set {
            objc_setAssociatedObject(self, UIViewController.RunTimeKey.HudKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIViewController.RunTimeKey.HudKey!) as? MBProgressHUD
        }
    }
    
    
    /// 运行时 key
    struct RunTimeKey {
        static let HudKey = UnsafeRawPointer.init(bitPattern: "HudKey".hashValue)
    }
}
