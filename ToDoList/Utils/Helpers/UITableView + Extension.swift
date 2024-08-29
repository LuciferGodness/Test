//
//  UITableView + Extension.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerCell(ofType type: UITableViewCell.Type) {
        register(UINib(nibName: type.identifier, bundle: nil), forCellReuseIdentifier: type.identifier)
    }
    
    func dequeueCell<T>(ofType type: T.Type) -> T? where T: UITableViewCell {
        dequeueReusableCell(withIdentifier: T.identifier) as? T
    }
}
