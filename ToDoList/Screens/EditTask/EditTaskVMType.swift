//
//  EditTaskVMType.swift
//  ToDoList
//
//  Created by Admin on 8/31/24.
//

import Foundation
import Combine

typealias EditTaskVMOutput = AnyPublisher<EditTaskResponseType, Error>

protocol EditTaskVMType {
    func transform(input: EditTaskVMInput) -> EditTaskVMOutput
    var state: TaskState { get }
    var count: Int { get }
}

struct UpdateTask {
    let title: String
    let description: String?
    let completed: Bool
}

struct EditTaskVMInput {
    let appear: PassthroughSubject<Void, Error>
    let save: PassthroughSubject<TaskDTO.TaskInfo, Error>
    let update: PassthroughSubject<UpdateTask, Error>
    let delete: PassthroughSubject<Void, Error>
}

enum EditTaskResponseType {
    case task(Task)
    case save
    case update
    case delete
    case failure(Error)
}
