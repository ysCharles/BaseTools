//
//  ViewController.swift
//  BaseToolsDemo
//
//  Created by Charles on 22/09/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import BaseTools

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "首页"
        
        let imgView = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        let img = UIImage(named:"WechatIMG160.jpeg")
        imgView.setWebImage(urlString: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg", placeHolder: img)
//        imgView.image = Utils.createQRCode(qrString: "Hello BaseProject Framework", qrImageName: "test")
        view.addSubview(imgView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 250, width: 100, height: 30)
        btn.setTitle("push vc", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(tabPush), for: .touchUpInside)
        view.addSubview(btn)
        
        let btn1 = UIButton(type: .custom)
        btn1.setBackgroundWebImage(urlString: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg", for: .normal)
        btn1.frame = CGRect(x: 100, y: 290, width: 170, height: 30)
        btn1.setTitle("push tableview", for: .normal)
        btn1.setTitleColor(UIColor.blue, for: .normal)
        btn1.addTarget(self, action: #selector(pushTableView), for: .touchUpInside)
        view.addSubview(btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setBackgroundWebImage(urlString: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg", for: .normal)
        btn2.frame = CGRect(x: 100, y: 430, width: 170, height: 30)
        btn2.setTitle("show progresss", for: .normal)
        btn2.setTitleColor(UIColor.blue, for: .normal)
        btn2.addTarget(self, action: #selector(showMB), for: .touchUpInside)
        view.addSubview(btn2)
        
        let btn3 = UIButton(type: .custom)
        btn3.setBackgroundWebImage(urlString: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg", for: .normal)
        btn3.frame = CGRect(x: 100, y: 470, width: 170, height: 30)
        btn3.setTitle("展示图片浏览器", for: .normal)
        btn3.setTitleColor(UIColor.blue, for: .normal)
        btn3.addTarget(self, action: #selector(showPhotos), for: .touchUpInside)
        view.addSubview(btn3)
        
//        testJson()
//        testNetUtils()
//        testDic2Model()
//        testMD5()
        testTextView()
        
        test1()
        test2()
        test3()
    }
    
    @objc func showPhotos() {
        let vc = Utils.getViewController(storyboardID: "ImageViewerDemoController", fromStoryboard: "Main")
        navigationController?.show(vc, sender: self)
        
    }
    
    private func testTextView() {
        let textView = TLTextView(frame: CGRect(x: 100, y: 330, width: 170, height: 90))
        textView.textColor = UIColor.orange
        textView.placeholder = "这是一个测试内容"
        view.addSubview(textView)
    }
    
    @objc private func showMB() {
        showTextHud(in: nil, duration: 1.5, yOffset: 100)
//        showNetLoadingHud(in: nil, msg: "Loading")
    }
    
    @objc private func tabPush() {
        let vc = QRCodeScanViewController(builder: QRCodeReaderViewBuilder(buildBlock: { (builder) in
            builder.startScanningAtLoad = true
        }))
        
        vc.didFindCode = { (result) in
            print(result)
        }
        
        navigationController?.show(vc, sender: self)
    }
    
    @objc private func pushTableView() {
        let vc = Utils.getViewController(storyboardID: "TableController", fromStoryboard: "Main")
        
        navigationController?.show(vc, sender: nil)
    }
    
    func testMD5() {
        let str = "123456"
        print(str.md5())
    }


    
    // MARK:- 编码解码测试
    func testJson() {
        let person = Person(name: "Charles", age: 30, pet: Pet(name: "八公", desc: "一条忠犬"))
        print(person.serialize2JsonString()!)
        let str = """
            {"name":"唐磊","age": 30,"pet":{"name":"小五","desc":"短毛猫"}}
        """
        let p = Person.deserialize(from: str)
        print(p!)
    }
    
    func testDic2Model() {
        let pDic  = ["name": "Charles", "age": 30, "pet":["name": "八公", "desc":"好狗一条"]] as [String : Any]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: pDic, options: .prettyPrinted) else {
            return
        }
        let jsonStr = String(data: jsonData, encoding: .utf8)
        print(jsonStr!)
    }
    
    // MARK:- 网络工具测试
    func testNetUtils() {
        NetUtils.setAdapter(adapter: RequestHeaderAdapter(headers: ["token": "erqer34134f3fd1r13","name":"Charles","age":"31"]))
//        NetUtils.getRequest(urlString: "https://httpbin.org/get", params:nil)
        NetUtils.getRequest(urlString: "https://httpbin.org/get", params: nil, success: { (response) in
            
            print(response)
        }) { (msg) in
            print(msg)
        }
        
        NetUtils.postRequest(urlString: "https://httpbin.org/post", params: nil, success: { (dic) in
            print(dic)
        }) { (msg) in
            print(msg)
        }
    }
}

// MARK:- 编码使用的 结构体
struct Person : Serializable {
//    enum CodingKeys: String, CodingKey {
//        case name = "_name"
//        case age = "_age"
//    }
    
    let name: String
    let age: Int
    let pet: Pet
}

struct Pet: Serializable {
    let name: String
    let desc: String
}

// MARK: - 测试 decode
/// 只有状态值和提示信息的模型转化
struct ModelObjet: Serializable {
    /// 状态值
    var status:Int? = nil
    /// 提示信息
    var message:String? = nil
}

/// 转换成数组模型
struct ModelObjetT<T: Serializable>: Serializable {
    /// 状态值
    var status:Int? = nil
    /// 提示信息
    var message:String? = nil
    /// 嵌套模型
    var data:T? = nil
}

// 转换成数组模型
struct ModelArrayT<T: Serializable>: Serializable {
    /// 状态值
    var status:Int? = nil
    /// 提示信息
    var message:String? = nil
    /// 嵌套模型
    var data:[T]? = nil
}

struct Test1: Serializable {
    lazy var name: Double? = { return (Double(test ?? "0.00") ?? 0.00) * 100 }()
    /// 测试文字
    var test:String?
}
struct Test2: Serializable {
    lazy var name: String? = { return "我是test_name转换之后的\(test_name ?? "")" }()
    /// 测试文字
    var test_name:String?

    var detial:[Detial]?

}
struct Detial: Serializable {
    var detial_name: String?
}

// json字符串一键转模型
func test1(){
    let jsonString = "{\"status\":1000,\"message\":\"操作成功\",\"data\":{\"test\":\"0.05\"}}"
//    let model = jsonString.jsonStringMapModel(ModelObjetT<Test1>.self)
    var model = ModelObjetT<Test1>.deserialize(from: jsonString)
    print(model?.data?.test ?? "test无值")
    print(model?.data?.name ?? 0.00)
    print("============华丽的分割线==============")
}
func test2(){
    let jsonString = "{\"status\":1000,\"message\":\"操作成功\",\"data\":{\"test_name\":\"Decodable\",\"detial\":[{\"detial_name\":\"看吧嵌套毫无压力\"}]}}"
//    let model = jsonString.jsonStringMapModel(ModelObjetT<Test2>.self)
    var model = ModelObjetT<Test2>.deserialize(from: jsonString)
    print(model?.data?.test_name ?? "test无值")
    print(model?.data?.name ?? "name无值")
    print(model?.data?.detial?.first?.detial_name ?? "detial_name无值")
}

func test3() {
    let jsonString = """
        {
            "status":1000,
            "message":"操作成功",
            "data":[
                {"name":"Pet1","desc": "pet1 desc"},{"name":"Pet2","desc": "pet2 desc"},{"name":"Pet3","desc": "pet3 desc"},{"name":"Pet4","desc": "pet4 desc"},
            ]
        }
    """
    let model = ModelArrayT<Pet>.deserialize(from: jsonString)
    print(model)
}


