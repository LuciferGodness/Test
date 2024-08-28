//
//  TaskListAssembler.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

enum TaskListAssembler {
    static func assemble() -> TaskListVC {
        let view = TaskListVC()
        let vm = TaskListVM()
        let apiService = ApiService()
        
        vm.view = view
        vm.apiService = apiService
        view.vm = vm
        
        return view
    }
}
