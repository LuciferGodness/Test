//
//  MockRepository.swift
//  ToDoListTests
//
//  Created by Admin on 9/2/24.
//

import Foundation
@testable import ToDoList

final class MockRepository {
    let testBundle: Bundle
    let testBundleId = "todo.ToDoListTests"
    
    init() {
        testBundle = Bundle(identifier: testBundleId)!
    }
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let url = testBundle.path(forResource: filename, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: url)),
              let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to load and decode JSON file: \(filename)")
        }
        return decodedData
    }
    
    var taskDTO: TaskDTO {
        return loadJSON(filename: "tasks", type: TaskDTO.self)
    }
}
