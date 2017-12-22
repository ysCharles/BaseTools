//
//  TableEmptyDemoController.swift
//  BaseToolsDemo
//
//  Created by Charles on 20/12/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import BaseTools

class TableEmptyDemoController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.emptyViewDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TableEmptyDemoController : TableEmptyViewDelegate {

}

extension TableEmptyDemoController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
