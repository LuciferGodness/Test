//
//  Endpoints.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

enum Endpoints {
    case getTasks
    
    var string: String {
        switch self {
        case .getTasks:
            "https://dummyjson.com/todos"
        }
    }
}
