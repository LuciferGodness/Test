//
//  CoreService.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import Foundation
import CoreData
import UIKit

protocol CoreServiceHelper {
    func saveTask(tasks: [TaskDTO.TaskInfo])
    func fetchTasks(completion: @escaping ([Task]?) -> Void)
    func deleteTasks(id: Int64)
    func updateTask(id: Int64, newData: UpdateTask, completion: @escaping (Bool) -> Void)
    func fetchTask(id: Int64, completion: @escaping (Task?) -> Void)
}

final class CoreService: CoreServiceHelper {
    func saveTask(tasks: [TaskDTO.TaskInfo]) {
        let context = DependencyContainer.shared.coreService
        
        context.perform {
            tasks.forEach { element in
                let task = Task(context: context)
                task.id = Int64(element.id)
                task.title = element.todo
                task.completed = element.completed
                task.dataOfCreation = element.date
                task.taskDescription = element.description
                
                do {
                    try context.save()
                } catch {
                    print("\(LocalizationKeys.saveError)\(error)")
                }
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([Task]?) -> Void) {
        let context = DependencyContainer.shared.coreService
        
        context.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            do {
                let tasks = try context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    return completion(tasks)
                }
            } catch {
                print("\(LocalizationKeys.error) \(error)")
                DispatchQueue.main.async {
                    return completion(nil)
                }
            }
        }
    }
    
    func fetchTask(id: Int64, completion: @escaping (Task?) -> Void) {
        let context = DependencyContainer.shared.coreService
        
        context.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let tasks = try context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    return completion(tasks.first)
                }
            } catch {
                print("\(LocalizationKeys.error) \(error)")
                DispatchQueue.main.async {
                    return completion(nil)
                }
            }
        }
    }
    
    func deleteTasks(id: Int64) {
        let context = DependencyContainer.shared.coreService
        
        context.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let tasks = try context.fetch(fetchRequest)
                
                if let task = tasks.first {
                    context.delete(task)
                    try context.save()
                }
            } catch {
                print("\(LocalizationKeys.error) \(error)")
            }
        }
    }
    
    func updateTask(id: Int64, newData: UpdateTask, completion: @escaping (Bool) -> Void) {
        let context = DependencyContainer.shared.coreService
        context.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                if let task = try context.fetch(fetchRequest).first {
                    task.title = newData.title
                    task.taskDescription = newData.description
                    task.completed = newData.completed
                    
                    try context.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("\(LocalizationKeys.error) \(error)")
                    completion(false)
                }
            }
        }
    }
}
