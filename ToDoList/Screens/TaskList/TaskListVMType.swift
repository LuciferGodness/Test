//
//  TaskListVMType.swift
//  ToDoList
//
//  Created by Admin on 8/30/24.
//

import Foundation
import Combine

typealias TaskVMOutput = AnyPublisher<TaskDTO, Error>

protocol TaskListVMType {
    func transform(input: TaskListVMInput) -> TaskVMOutput
}

struct TaskListVMInput {
    let appear: PassthroughSubject<Void, Error>
    let appearFromDatabase: PassthroughSubject<Void, Error>
}

struct Section {
    var mainCellTitle: MainCellData
    var expandableCellOptions: String?
    var isExpandableCellsHidden: Bool
}

struct MainCellData {
    var title: String
    var completable: Bool
    var date: Date?
}
