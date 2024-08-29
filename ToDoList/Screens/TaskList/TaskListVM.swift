//
//  TaskListVM.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation
import Combine

typealias TaskVMOutput = AnyPublisher<TaskDTO, Error>

protocol TaskListVMType {
    func transform(input: TaskListVMInput) -> TaskVMOutput
}

struct TaskListVMInput {
    let appear: PassthroughSubject<Void, Error>
}

final class TaskListVM: TaskListVMType {
    var apiService: PApiService?
    
    func transform(input: TaskListVMInput) -> TaskVMOutput {
        let appear = input.appear.flatMap { _ in
            self.loadData()
        }
        
        return appear.eraseToAnyPublisher()
    }
    
    private func loadData() -> TaskVMOutput {
        return Future { promise in
            self.apiService?.getTasks { result in
                switch result {
                case .success(let taskDTO):
                    promise(.success(taskDTO))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
