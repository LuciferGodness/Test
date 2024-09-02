//
//  MockCoreService.swift
//  ToDoListTests
//
//  Created by Admin on 9/2/24.
//

import Foundation
@testable import ToDoList

enum MockCoreServiceFunc {
    case saveTask
    case fetchTasks
    case fetchTask
    case deleteTask
    case updateTask
}

import CoreData

class MockCoreDataStack {
    static let shared = MockCoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

final class MockCoreService: CoreServiceHelper {
    static var isCalled: [MockCoreServiceFunc: Bool] = [:]
    static var tasksToReturn: [TaskDTO.TaskInfo]?
    static var fetchTasksCompletion: () -> [Task]? = { nil }
    
    static func reset() {
        isCalled = [:]
        tasksToReturn = []
        fetchTasksCompletion = { nil }
    }
    
    func saveTask(tasks: [ToDoList.TaskDTO.TaskInfo]) {
        MockCoreService.isCalled[.saveTask] = true
        MockCoreService.tasksToReturn = tasks
    }
    
    func fetchTasks(completion: @escaping ([ToDoList.Task]?) -> Void) {
        MockCoreService.isCalled[.fetchTasks] = true
        DispatchQueue.main.async {
            completion(MockCoreService.fetchTasksCompletion())
        }
    }
    
    func deleteTasks(id: Int64) {
        MockCoreService.isCalled[.deleteTask] = true
    }
    
    func updateTask(id: Int64, newData: ToDoList.UpdateTask, completion: @escaping (Bool) -> Void) {
        MockCoreService.isCalled[.updateTask] = true
        DispatchQueue.main.async {
            if let task = MockCoreService.tasksToReturn {
                let success = task.contains { $0.id == id }
                completion(success)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchTask(id: Int64, completion: @escaping (ToDoList.Task?) -> Void) {
        MockCoreService.isCalled[.fetchTask] = true
        DispatchQueue.main.async {
            if let mockTask = MockCoreService.tasksToReturn?.first(where: { $0.id == id }) {
                let context = MockCoreDataStack.shared.context
                let task = ToDoList.Task(context: context)
                task.id = Int64(mockTask.id)
                task.title = mockTask.todo
                task.completed = mockTask.completed
                task.dataOfCreation = mockTask.date
                task.taskDescription = mockTask.description
                completion(task)
            } else {
                completion(nil)
            }
        }
    }
}
