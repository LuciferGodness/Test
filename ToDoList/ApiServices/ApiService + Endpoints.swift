//
//  ApiService + Endpoints.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

protocol ApiServiceHelper {
    func getTasks(completion: @escaping (Result<TaskDTO, Error>) -> Void)
}

extension ApiService: ApiServiceHelper {
    func getTasks(completion: @escaping (Result<TaskDTO, Error>) -> Void) {
        sendRequest(url: .getTasks, completion: completion)
    }
}
