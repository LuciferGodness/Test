//
//  CoreService.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import Foundation
import CoreData
import UIKit

protocol PCoreService {
    func saveTask(tasks: TaskDTO.TaskInfo)
    func fetchTasks(completion: @escaping ([Task]?) -> Void)
    func deleteTasks(id: Int16)
    func updateTask(id: Int16, newTitle: String?, newDetails: String?, completion: @escaping (Bool) -> Void)
}

final class CoreService {
    func saveTask(tasks: TaskDTO.TaskInfo) {
        let context = DependencyContainer.shared.coreService
        
        context.perform {
            let task = Task(context: context)
            task.id = Int16(tasks.id)
            task.title = tasks.todo
            task.completed = tasks.completed
            task.dataOfCreation = tasks.date
            task.taskDescription = tasks.description
            
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения \(error)")
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
                print("Ошибка \(error)")
                DispatchQueue.main.async {
                    return completion(nil)
                }
            }
        }
    }
    
    func deleteTasks(id: Int16) {
        let context = DependencyContainer.shared.coreService
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            if let task = tasks.first {
                context.delete(task)
                try context.save()
            } else {
                print("Задача с ID \(id) не найдена.")
            }
        } catch {
            print("Ошибка \(error)")
        }
    }
    
    func updateTask(id: Int16, newTitle: String?, newDetails: String?, completion: @escaping (Bool) -> Void) {
        let context = DependencyContainer.shared.coreService
        context.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                if let task = try context.fetch(fetchRequest).first {
                    task.title = newTitle ?? task.title
                    task.taskDescription = newDetails ?? task.taskDescription
                    
                    try context.save()
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Задача с ID \(id) не найдена.")
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Ошибка обновления данных: \(error)")
                    completion(false)
                }
            }
        }
    }
}
