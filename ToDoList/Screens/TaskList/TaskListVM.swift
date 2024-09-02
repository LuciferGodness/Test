//
//  TaskListVM.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation
import Combine

final class TaskListVM: TaskListVMType {
    var apiService: ApiServiceHelper?
    var coreService: CoreServiceHelper?
    
    func transform(input: TaskListVMInput) -> TaskVMOutput {
        let appear = input.appear.flatMap { _ in
            self.loadData()
        }
        
        let appearFromDatabase = input.appearFromDatabase.flatMap { _ in
            self.getDataFromDatabase()
        }
        
        return Publishers.Merge(appear, appearFromDatabase)
            .eraseToAnyPublisher()
    }
    
    private func loadData() -> TaskVMOutput {
        return Future { promise in
            self.apiService?.getTasks { result in
                switch result {
                case .success(let taskDTO):
                    self.saveData(tasks: taskDTO.todos)
                    promise(.success(.tasks(taskDTO)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getDataFromDatabase() -> TaskVMOutput {
        return Future { promise in
            self.coreService?.fetchTasks { tasks in
                if let tasks = tasks {
                    let taskInfos = tasks.map { task in
                        TaskDTO.TaskInfo(id: Int(task.id),
                                         todo: task.title ?? "",
                                         completed: task.completed,
                                         userId: 0,
                                         date: task.dataOfCreation,
                                         description: task.taskDescription)
                    }
                    let taskDTO = TaskDTO(
                        todos: taskInfos,
                        total: taskInfos.count,
                        skip: 0,
                        limit: taskInfos.count
                    )
                    promise(.success(.tasks(taskDTO)))
                } else {
                    promise(.failure(NSError(domain: LocalizationKeys.fetchError.localized, code: -1, userInfo: [NSLocalizedDescriptionKey: LocalizationKeys.fetchFail.localized])))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func saveData(tasks: [TaskDTO.TaskInfo]) {
        coreService?.saveTask(tasks: tasks)
    }
}
