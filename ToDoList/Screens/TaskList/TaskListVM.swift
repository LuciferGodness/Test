//
//  TaskListVM.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

protocol PTaskListVM {
    func loadData()
}

final class TaskListVM: PTaskListVM {
    var apiService: PApiService?
    weak var view: PTaskListVC?
    
    func loadData() {
        apiService?.getTasks(completion: { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        })
    }
}
