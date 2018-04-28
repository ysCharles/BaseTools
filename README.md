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









