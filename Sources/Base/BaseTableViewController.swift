//
//  BaseTableViewController.swift
//  BaseProject
//
//  Created by Charles on 10/03/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

open class BaseTableViewController: BaseViewController {
    
    @IBOutlet public weak var tableView: UITableView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.tlReloadData()
    }
}
