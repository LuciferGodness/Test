//
//  TaskListAssembler.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

enum TaskListAssembler {
    static func assemble() -> TaskListVC {
        let vm = TaskListVM()
        let apiService = ApiService()
        
        vm.apiService = apiService
        let view = TaskListVC(vm: vm)
        
        return view
    }
}
