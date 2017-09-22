//
//  BaseTableViewController.swift
//  BaseProject
//
//  Created by Charles on 10/03/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

open class BaseTableViewController: BaseViewController {
    
    public weak var tableView: UITableView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        let table = UITableView(frame: view.bounds)
        table.backgroundColor = UIColor.clear
        view.addSubview(table)
//        table.delegate = self
//        table.dataSource = self
        tableView = table
    }
}
