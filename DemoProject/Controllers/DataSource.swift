//
//  DataSource.swift
//  DemoProject
//
//  Created by Ankush Sharma on 13/04/22.
//

import Foundation
import UIKit

protocol TableViewCompatible {
    
    func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell
    
}

protocol Configurable {
    
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
    
}
