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
        
        let imgView = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        imgView.image = Utils.createQRCode(qrString: "Hello BaseProject Framework", qrImageName: "test")
        view.addSubview(imgView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 250, width: 100, height: 30)
        btn.setTitle("push vc", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(tabPush), for: .touchUpInside)
        view.addSubview(btn)
        
        let person = Person(name: "Charles", age: 30, pet: Pet(name: "八公", desc: "一条忠犬"))
        print(person.serialize2JsonString()!)
        let str = """
            {"name":"唐磊","age": 30,"pet":{"name":"小五","desc":"短毛猫"}}
        """
        let p = Person.deserialize(from: str)
        print(p)
    }
    
    @objc private func tabPush() {
        let vc = QRCodeScanViewController()
        vc.succeessCallback = { msg in Utils.showAlertView(title: "扫描结果", message:  msg, confirmTitle: nil, cancelTitle: "取消", confirmAction: nil)}
        //        vc.view.backgroundColor = UIColor.blue
        //        vc.navigationItem.title = "push VC"
        navigationController?.show(vc, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

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

