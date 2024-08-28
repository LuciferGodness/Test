//
//  TaskListVC.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import UIKit

protocol PTaskListVC: AnyObject {
    
}

final class TaskListVC: UIViewController, PTaskListVC {
    var vm: PTaskListVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        if !AppState.current.isFirstRun {
            
            AppState.current.isFirstRun = true
        }
        vm?.loadData()
    }
}
