//
//  EditTaskVC.swift
//  ToDoList
//
//  Created by Admin on 8/31/24.
//

import Foundation
import Combine

enum TaskState {
    case create
    case edit
}

final class EditTaskVM: EditTaskVMType {
    let taskId: Int?
    let coreService: CoreServiceHelper
    var state: TaskState
    var count: Int
    
    init(taskId: Int?,
         state: TaskState,
         coreService: CoreServiceHelper,
         count: Int) {
        self.taskId = taskId
        self.state = state
        self.coreService = coreService
        self.count = count
    }
    
    func transform(input: EditTaskVMInput) -> EditTaskVMOutput {
        let appear = input.appear.flatMap { _ in
            self.loadTask()
        }
        
        let save = input.save.flatMap { task in
            self.saveTask(task: task)
        }
        
        let delete = input.delete.flatMap { _ in
            self.deleteTask()
        }
        
        let update = input.update.flatMap { task in
            self.updateTask(task: task)
        }
        
        return Publishers.Merge4(appear, delete, save, update).eraseToAnyPublisher()
    }
    
    private func loadTask() -> EditTaskVMOutput {
        return Future { promise in
            guard let taskId = self.taskId else { return }
            self.coreService.fetchTask(id: Int16(taskId), completion: { response in
                if let response = response {
                    promise(.success(.task(response)))
                } else {
                    promise(.failure(NSError(domain: LocalizationKeys.fetchError.localized, code: -1, userInfo: [NSLocalizedDescriptionKey: LocalizationKeys.fetchFail.localized])))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    private func deleteTask() -> EditTaskVMOutput {
        return Future { promise in
            guard let taskId = self.taskId else { return }
            self.coreService.deleteTasks(id: Int16(taskId))
            promise(.success(.delete))
        }
        .eraseToAnyPublisher()
    }
    
    private func saveTask(task: TaskDTO.TaskInfo) -> EditTaskVMOutput {
        return Future { promise in
            self.coreService.saveTask(tasks: [task])
            promise(.success(.save))
        }
        .eraseToAnyPublisher()
    }
    
    private func updateTask(task: UpdateTask) -> EditTaskVMOutput {
        return Future { promise in
            guard let taskId = self.taskId else { return }
            self.coreService.updateTask(id: Int16(taskId), newData: task) { state in
                if state {
                    promise(.success(.update))
                } else {
                    promise(.failure(NSError(domain: LocalizationKeys.fetchError.localized, code: -1, userInfo: [NSLocalizedDescriptionKey: LocalizationKeys.fetchFail.localized])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
