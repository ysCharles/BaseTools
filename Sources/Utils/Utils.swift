//
//  Utils.swift
//  smk
//
//  Created by Charles on 23/02/2017.
//  Copyright © 2017 Matrix. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

public struct Utils {
    
    /// 是否是新版本
    ///
    /// - Returns: true：是新版本 false:不是新版本
    @discardableResult
    public static func isNewVersion() -> Bool {
        guard let info = Bundle.main.infoDictionary else {
            return false
        }
        
        // 获取 app 当前版本
        guard let currentVersion = info["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        let key = "app_version"
        guard let oldVersion = UserDefaults.standard.string(forKey: key) else {
            //保存当前版本
            UserDefaults.standard.set(currentVersion, forKey: key)
            UserDefaults.standard.synchronize()
            return true // 没有获取到旧版本号  就是没有保存过版本号 肯定是 新安装
        }
        
        if oldVersion == currentVersion { // 保存版本号与当前版本号一致  不是新版本
            return false
        } else { //保存版本号与当前版本号不一致  是新版本
            //保存当前版本
            UserDefaults.standard.set(currentVersion, forKey: key)
            UserDefaults.standard.synchronize()
            return true
        }
    }
    
    
    // MARK:- 从 storyboard 中唤醒 viewcontroller
    /// 从 storyboard 中唤醒 viewcontroller
    ///
    /// - Parameters:
    ///   - storyboardID: viewcontroller 在 storyboard 中的 id
    ///   - fromStoryboard: storyboard 名称
    /// - Returns: UIviewcontroller
    public static func getViewController(storyboardID: String, fromStoryboard: String) -> UIViewController {
        let story = UIStoryboard(name: fromStoryboard, bundle: Bundle.main)
        return story.instantiateViewController(withIdentifier: storyboardID)
    }
    
    // MARK:- 生成二维码图片
    /// 生成二维码图片
    ///
    /// - Parameters:
    ///   - qrString: 二维码信息字符串
    ///   - qrImageName: 二维码图片中间的图标（可为空）
    /// - Returns: 二维码图片
    public static func createQRCode(qrString: String?, qrImageName: String?) -> UIImage? {
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8, allowLossyConversion: false)
            //创建一个二维码滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter!.setValue(stringData, forKey: "inputMessage")
            qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter!.outputImage
            
            //创建一个颜色滤镜 黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter!.setDefaults()
            colorFilter!.setValue(qrCIImage, forKey: "inputImage")
            colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            //返回二维码 image
            let ciImage = colorFilter?.outputImage?.transformed(by: CGAffineTransform(scaleX: 5, y: 5))
            guard let ci = ciImage else {
                return nil
            }
            let codeImage = UIImage(ciImage: ci)
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            guard let imageName = qrImageName else { return codeImage }
            if let iconImage = UIImage(named:  imageName) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width:rect.size.width * 0.25,height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
    
    // MARK:- 应用跳转
    /// 跳转到App Store，记得将 http:// 替换为 itms:// 或者 itms-apps://：  需要真机调试
    ///
    /// - Parameters:
    ///   - vc: 跳转时所在控制器
    ///   - url: url
    public static func openAppStore(vc: UIViewController, url: String) {
        //在 url 内查找 appid
        if let number = url.range(of: "[0-9]{9}",options: String.CompareOptions.regularExpression) {
            let appId = String(url[number])
            let productView = SKStoreProductViewController()
            //productView.delegate = vc
            productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appId], completionBlock: { (result, error) in
                if !result {
                    //点击取消
                    productView.dismiss(animated: true, completion: nil)
                }
            })
            vc.showDetailViewController(productView, sender: vc)
        } else {
            showAlertView(title: "提示", message: "打开App Store失败，请稍后再试", confirmTitle: "确定", cancelTitle:  nil, confirmAction: nil)
        }
    }
    
    /// 拨打电话 ,里面会判断是否需要拨打号码 外部不需要调用判断 需要真机调试
    ///
    /// - Parameters:
    ///   - vc: 拨打电话时所在的控制器
    ///   - number: 电话号码
    public static  func callPhone(number: String) {
        showAlertView(title: "拨打号码", message: "确认拨打次号码\(number)", confirmTitle: "确定", cancelTitle: "取消", confirmAction: { 
            let telUrl = "tel:" + number
            let url = URL(string: telUrl)
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }, cancelAction: nil)
    }
    
    /// 打开浏览器 真机调试
    ///
    /// - Parameter url: 需要打开的 url
    public static func openBrowser(url: String) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: url)!)
        } else {
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    
    // MARK:获取版本信息
    /// 获取 app 版本
    ///
    /// - Parameter type: 类型0 = CFBundleShortVersionString   1 = CFBundleVersion 默认获取0
    /// - Returns: 版本信息字符串
    public static func getVersion(type: Int = 0) -> String {
        let infoDictionary = Bundle.main.infoDictionary
        var version: String = ""
        if type == 0 {
            let majorVersion: AnyObject? = infoDictionary!["CFBundleShortVersionString"] as AnyObject?
            version = majorVersion as! String
        }
        if type == 1 {
            let majorVersion: AnyObject? = infoDictionary!["CFBundleVersion"] as AnyObject?
            version = majorVersion as! String
        }
        return version
    }
    
    // MARK:- 弹窗相关
    public typealias AlertTapButtonAction = () -> Void
    /// 弹窗
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 详细信息
    ///   - confirmTitle: 确认标题
    ///   - cancelTitle: 取消标题
    ///   - confirmAction: 确认点击操作
    ///   - cancelAction: 取消点击操作
    public static func showAlertView( title: String?, message: String?, confirmTitle: String?, cancelTitle: String?, confirmAction: AlertTapButtonAction? , cancelAction: AlertTapButtonAction? = nil) {
        let alert = AlertView()
        if let ct = cancelTitle {
            alert.addButton(ct, action: cancelAction)
        }
        if let cft = confirmTitle {
            alert.addButton(cft, action: confirmAction)
        }
        
        alert.showInfo(title ?? "提示", subTitle: message ?? "")
    }
}
