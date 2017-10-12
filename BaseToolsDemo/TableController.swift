//
//  TableController.swift
//  BaseToolsDemo
//
//  Created by Charles on 12/10/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import BaseTools

class TableController: UIViewController {

    var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "tableView"
        
        tableView = UITableView()
        tableView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.addSubview(tableView!)
        
        
        tableView!.delegate = self
        tableView!.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

typealias TableControllerDelegate = TableController
extension TableControllerDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
}

typealias TableControllerDataSource = TableController
extension TableControllerDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TableCell")
        var str = "    测试空格 trim      "
        str.trim()
        cell.textLabel?.text = "标题\(str)\(indexPath.section)"
        cell.detailTextLabel?.text = "详细内容\(indexPath.section)"
        return cell
    }
}
