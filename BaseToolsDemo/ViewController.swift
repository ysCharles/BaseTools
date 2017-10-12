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
        imgView.image = Utils.createQRCode(qrString: "Hello BaseProject Framework", qrImageName: "test")
        view.addSubview(imgView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 250, width: 100, height: 30)
        btn.setTitle("push vc", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(tabPush), for: .touchUpInside)
        view.addSubview(btn)
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 100, y: 290, width: 170, height: 30)
        btn1.setTitle("push tableview", for: .normal)
        btn1.setTitleColor(UIColor.blue, for: .normal)
        btn1.addTarget(self, action: #selector(pushTableView), for: .touchUpInside)
        view.addSubview(btn1)
        
//        testJson()
//        testNetUtils()
//        testDic2Model()
    }
    
    @objc private func tabPush() {
        let vc = QRCodeScanViewController()
        vc.succeessCallback = { msg in Utils.showAlertView(title: "扫描结果", message:  msg, confirmTitle: nil, cancelTitle: "取消", confirmAction: nil)}
        //        vc.view.backgroundColor = UIColor.blue
        //        vc.navigationItem.title = "push VC"
        navigationController?.show(vc, sender: self)
    }
    
    @objc private func pushTableView() {
        let vc = Utils.getViewController(storyboardID: "TableController", fromStoryboard: "Main")
        navigationController?.show(vc, sender: nil)
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
        let pDic  = ["name": "Charles", "age": 30, "pet":["name": "八公", "desc":"好狗一条"]] as Dictionary
        print(pDic)
    }
    
    // MARK:- 网络工具测试
    func testNetUtils() {
        NetUtils.getRequest(urlString: "https://httpbin.org/get", params:nil)
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

