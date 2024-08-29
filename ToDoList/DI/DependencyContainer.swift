//
//  DependencyContainer.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import Foundation
import UIKit

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    lazy var coreService = {
        return (UIApplication.shared.delegate as! AppDelegate).backgroundContext
    }()
}
