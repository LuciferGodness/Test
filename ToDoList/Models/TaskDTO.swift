//
//  TaskDTO.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

struct TaskDTO: Decodable {
    let todos: [TaskInfo]
    let total: Int
    let skip: Int
    let limit: Int
    
    struct TaskInfo: Decodable {
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
}
