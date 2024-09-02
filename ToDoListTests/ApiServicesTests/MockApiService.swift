//
//  MockApiService.swift
//  ToDoListTests
//
//  Created by Admin on 9/2/24.
//

import Foundation
@testable import ToDoList

enum MockApiServiceFunc {
    case getTasks
}

final class MockApiService: ApiServiceHelper {
    static var isCalled: [MockApiServiceFunc: Bool] = [:]
    static var shouldReturnError = false
    
    let repository = MockRepository()
    
    static func reset() {
        isCalled = [:]
        shouldReturnError = false
    }
    
    func getTasks(completion: @escaping (Result<TaskDTO, Error>) -> Void) {
        MockApiService.isCalled[.getTasks] = true
        let taskDTO = repository.taskDTO
        if MockApiService.shouldReturnError {
            completion(.failure(NSError(domain: "TestError", code: -1, userInfo: nil)))
        } else {
            completion(.success(taskDTO))
        }
    }
}
