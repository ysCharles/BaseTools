# BaseTools

## 1.主要功能

* 工具类


* 快速提示框
* 网络请求
* json与 model 互转
* 常量
* tableview 空数据
* Extension
* 二维码



## 2.配置方式

在要使用的项目跟目录，创建 Cartfile 文件，添加下一行

```
github "ysCharles/BaseTools"
```

命令行输入

```
carthage update --platforn iOS
```

在项目的 Target→General→Linked Frameworks Libraries→`+`添加依赖，包括：

>MBProgressHUD.framework
>
>BaseTools.framework
>
>Alamofire.framework
>
>SnapKit.framework
>
>Kingfisher.framework

在项目的 Target→Build Phases→`+ `Run Script，`/usr/local/bin/carthage copy-frameworks`：

在 input files中添加

>$(SRCROOT)/Carthage/Build/iOS/MBProgressHUD.framework
>
>$(SRCROOT)/Carthage/Build/iOS/BaseTools.framework
>
>$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework
>
>$(SRCROOT)/Carthage/Build/iOS/SnapKit.framework
>
>$(SRCROOT)/Carthage/Build/iOS/Kingfisher.framework

在 Out Files中添加

>$(BUILT_PRODUCTS_DIR)/$$(FRAMEWORKS_FOLDER_PATH)/BProgressHUD.framework
>
>$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/BaseTools.framework
>
>$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/Alamofire.framework
>
>$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/SnapKit.framework
>
>$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/Kingfisher.framework

配置完成。

##3.使用

在使用的地方导入

```swift
import BaseTools
```



## 4.功能简介

### 4.1 工具类

#### 4.1.1 Utils

`Utils`工具类封装了一些常用的方法

```swift
    // MARK:- 从 storyboard 中唤醒 viewcontroller
    /// 从 storyboard 中唤醒 viewcontroller(MainBundle中的 storyboard)
    ///
    /// - Parameters:
    ///   - storyboardID: viewcontroller 在 storyboard 中的 id
    ///   - fromStoryboard: storyboard 名称
    /// - Returns: UIviewcontroller
    public static func getViewController(storyboardID: String, fromStoryboard: String) ->UIViewController 

    // MARK:- 生成二维码图片
    /// 生成二维码图片
    ///
    /// - Parameters:
    ///   - qrString: 二维码信息字符串
    ///   - qrImageName: 二维码图片中间的图标（可为空）
    /// - Returns: 二维码图片
    public static func createQRCode(qrString: String?, qrImageName: String?) -> UIImage?

    // MARK:- 应用跳转
    /// 跳转到App Store，记得将 http:// 替换为 itms:// 或者 itms-apps://：  需要真机调试
    ///
    /// - Parameters:
    ///   - vc: 跳转时所在控制器
    ///   - url: url
    public static func openAppStore(vc: UIViewController, url: String) 
    
    
    /// 打开浏览器 真机调试
    ///
    /// - Parameter url: 需要打开的 url
    public static func openBrowser(url: String) 

    // MARK:获取版本信息
    /// 获取 app 版本
    ///
    /// - Parameter type: 类型0 = CFBundleShortVersionString   1 = CFBundleVersion 默认获取0
    /// - Returns: 版本信息字符串
    public static func getVersion(type: Int = 0) -> String

```



#### 4.1.2 NetUtils

`NetUtils`是对 `Alamofire`库进行的封装

```swift
public typealias SuccessClosure = (String) -> Void
public typealias FailureClosure = (String) -> Void
/// 网络请求参数格式 目前支持两种 form表单格式  json格式
///
/// - form: form表单格式
/// - json: json格式
public enum NetparameterType {
    case form
    case json
}
/// 网络请求工具
public class NetUtils: NSObject {
    /// get 网络请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 参数
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    /// - Returns: request 对应的 key 可用于取消 request 任务
    @discardableResult
    public static func getRequest(urlString: String,
                                  params: [String: Any]?,
                                  success: @escaping SuccessClosure,
                                  failure:@escaping FailureClosure,
                                  parameterType: NetparameterType = .form) -> String 
    
    /// post 网络请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 参数
    ///   - success: 请求陈宫回调
    ///   - failure: 请求失败回调
    /// - Returns: request 对应的 key 可用于取消 request 任务
    @discardableResult
    public  static func postRequest(urlString: String,
                                    params: [String: Any]?,
                                    success: @escaping SuccessClosure,
                                    failure:@escaping FailureClosure,
                                    parameterType: NetparameterType = .form) -> String 
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - urlString: 上传地址
    ///   - image: 图片
    ///   - progress: 进度回调
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public static func upload(urlString: String,
                              image: UIImage,
                              progress: @escaping (Double)->Void,
                              success: @escaping SuccessClosure,
                              failure: @escaping FailureClosure) 
    
    /// 取消网络请求
    ///
    /// - Parameter key: 网络请求对应的 key
    public static func cancelRequest(forKey key: String) 
    
    
    /// 设置 RequestAdapter 通产用于给 request 设置 heaher
    ///
    /// - Parameter adapter: 适配器
    public static func setAdapter(adapter: RequestAdapter)
}

// MARK:- request适配器
/// 给 request 添加 header
public class RequestHeaderAdapter: RequestAdapter {
    public init(headers: [String: String]) 
    
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest 
}

    
```





