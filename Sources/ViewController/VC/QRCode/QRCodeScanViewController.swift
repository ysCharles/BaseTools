//
//  ScanQRCodeControllerViewController.swift
//  smk
//
//  Created by Charles on 24/02/2017.
//  Copyright © 2017 Matrix. All rights reserved.
//

import UIKit
import AVFoundation

let ratio = SCREEN_WIDTH / 320.0 //以iphone5为基础 坐标都以iphone5为基准 进行代码的适配

//尺寸
let kBgImgX = 45 * ratio
let kBgImgY = (64+60) * ratio
let kBgImgWidth = 230 * ratio
let kScrollLineHeight = 20 * ratio

let kTipHeight = 40 * ratio
let kTipY = kBgImgY + kBgImgWidth + kTipHeight

let kLampX = (SCREEN_WIDTH - kLampWidth) / 2
let kLampY = (SCREEN_HEIGHT - kLampWidth - 30 * ratio)
let kLampWidth = 64 * ratio

let kBgAlpha: CGFloat = 0.6

let bgImg_img   = "scanBackground"
let Line_img    = "scanLine"
//let turn_on     = "turn_on"
//let turn_off    = "turn_off"

/// 扫描二维码控制器
public class QRCodeScanViewController: BaseViewController {
    
    public typealias SuccessCallback = (_ QRCodeInfo: String) -> Void
    
    /// 扫描成功回调
    public var succeessCallback: SuccessCallback?
    
    // MARK:-  life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        up = true
        _ = self.session
        
        //1.添加一个可见的扫描有效区域的框（这里直接是设置一个背景图片）
        self.view.addSubview(self.bgImg)
        //2.添加一个上下循环运动的线条（这里直接是添加一个背景图片来运动）
        self.view.addSubview(self.scrollLine)
        //3.添加其他有效控件
        self.view.addSubview(self.tip)
        
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.session.startRunning()
        //计时器添加到循环中去
        self.link.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
        //计时器从循环中移除
        self.link.remove(from: .main, forMode: .commonModes)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- 属性
    /// 二维码信息字符串
    fileprivate var QRCode: String?
    
    /// 输入输出会话
    fileprivate lazy var session: AVCaptureSession = {
        //1.获取输入设备（摄像头）
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            //2.根据输入设备创建输入对象
            let input = try AVCaptureDeviceInput(device: device!)
            //3.创建元数据的输出对象
            let output = AVCaptureMetadataOutput()
            //4.设置代理监听输出对象输出的数据,在主线程中刷新
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // 5.创建会话(桥梁)
            let session = AVCaptureSession()
            //实现高质量的输出和摄像，默认值为AVCaptureSessionPresetHigh，可以不写
            session.sessionPreset = AVCaptureSession.Preset.high
            // 6.添加输入和输出到会话中（判断session是否已满）
            if session.canAddInput(input) {
                session.addInput(input)
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            // 7.告诉输出对象, 需要输出什么样的数据 (二维码还是条形码等) 要先创建会话才能设置
            //[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode]
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // 8.创建预览图层
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(previewLayer, at: 0)
            
            //9.设置有效扫描区域，默认整个图层(很特别，1、要除以屏幕宽高比例，2、其中x和y、width和height分别互换位置)
            let rect = CGRect(x: kBgImgY / SCREEN_HEIGHT, y: kBgImgX / SCREEN_WIDTH, width: kBgImgWidth / SCREEN_HEIGHT, height: kBgImgWidth / SCREEN_WIDTH)
            output.rectOfInterest = rect
            
            //10.设置中空区域，即有效扫描区域(中间扫描区域透明度比周边要低的效果)
            let maskView: UIView = UIView(frame: self.view.bounds)
            maskView.backgroundColor = UIColor.black.withAlphaComponent(kBgAlpha)
            self.view.addSubview(maskView)
            let rectPath: UIBezierPath = UIBezierPath(rect: self.view.bounds)
            rectPath.append(UIBezierPath(roundedRect: CGRect(x:kBgImgX, y:kBgImgY, width:kBgImgWidth, height:kBgImgWidth), cornerRadius: 1).reversing())
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = rectPath.cgPath
            maskView.layer.mask = shapeLayer
            
            return session
        } catch {
            // TODO:- 错误处理
            print("error")
        }
        
        return AVCaptureSession()//session
    }()
    
    /// 计时器
    fileprivate lazy var link: CADisplayLink = {
        
        let link = CADisplayLink(target: self, selector: #selector(LineAnimation))
        return link
    }()
    
    /// 实际有效扫描区域的背景图(亦或者自己设置一个边框)
    fileprivate lazy var bgImg: UIImageView = {
        let bgImg = UIImageView(frame: CGRect(x: kBgImgX, y: kBgImgY, width: kBgImgWidth, height: kBgImgWidth))
        bgImg.image = UIImage(named: bgImg_img, in: Bundle(for: self.classForCoder), compatibleWith: nil)//UIImage(named: bgImg_img)
        return bgImg
    }()
    
    /// 有效扫描区域循环往返的一条线（这里用的是一个背景图）
    fileprivate lazy var scrollLine: UIImageView = {
        let scrollLine = UIImageView(frame: CGRect(x: kBgImgX, y: kBgImgY, width: kBgImgWidth, height: kScrollLineHeight))
        scrollLine.image = UIImage(named: Line_img, in: Bundle(for: self.classForCoder), compatibleWith: nil)//UIImage(named: Line_img)
        return scrollLine
    }()
    
    /// 扫码有效区域外自加的文字提示
    fileprivate lazy var tip: UILabel = {
        let tip = UILabel(frame: CGRect(x: kBgImgX, y: kTipY, width: kBgImgWidth, height: kTipHeight))
        tip.text = "自动扫描框内二维码"
        tip.numberOfLines = 0
        tip.textColor = UIColor.white
        tip.textAlignment = .center
        tip.font = UIFont.systemFont(ofSize: 14)
        return tip
    }()
    
    /// 用于记录scrollLine的上下循环状态
    fileprivate var up = false
    
    // MARK:- 线条运动的动画
    @objc func LineAnimation() {
        if up {
            var y = self.scrollLine.frame.origin.y
            y += 2
            var rect = self.scrollLine.frame
            rect.origin.y = y
            self.scrollLine.frame = rect
            if y >= kBgImgY + kBgImgWidth - kScrollLineHeight {
                up = false
            }
        } else {
            var y = self.scrollLine.frame.origin.y
            y -= 2
            var rect = self.scrollLine.frame
            rect.origin.y = y
            self.scrollLine.frame = rect
            if y <= kBgImgY {
                up = true
            }
        }
    }
}

extension QRCodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            //1.停止扫描
            self.session.stopRunning()
            //2.停止定时器
//            self.link .remove(from: RunLoop.main, forMode: .commonModes)
            //3.取出扫描得到的数据
            let obj = metadataObjects.last as! AVMetadataMachineReadableCodeObject
            if let success = succeessCallback {
                success(obj.stringValue!)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
