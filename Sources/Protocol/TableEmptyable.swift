//
//  TableEmptyable.swift
//  BaseProject
//
//  Created by Charles on 05/09/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

public protocol TableEmptyable {
    /// 列表是否为空
    var isEmptyData: Bool { get }
    /// 提供占位view,该view将占据tableView的tableFooterView
    var placeHolderView: UIView { get }
    /// 建议在reloadData前,调用该方法
    func setPlaceholderIfNeed()
}

// MARK: - 扩展默认实现
extension TableEmptyable where Self: BaseTableViewController {
    public var isEmptyData: Bool {
        let sectionCount: Int = tableView.numberOfSections
        if sectionCount == 0 {
            return true
        }
        
        for section in 0 ..< sectionCount {
            if tableView.numberOfRows(inSection: section) != 0 {
                return false
            }
        }
        
        return true
    }
    
    public var placeHolderView: UIView {
        get {
            let imgView = UIImageView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
            
            imgView.image = UIImage(named: "00xx")
            
            imgView.backgroundColor = UIColor.blue
            return imgView
        }
    }
    
    public func setPlaceholderIfNeed() {
        if self.isEmptyData {
            self.tableView.tableFooterView = placeHolderView
        } else {
            self.tableView.tableFooterView = UIView()
        }
    }
}
