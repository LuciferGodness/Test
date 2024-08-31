//
//  EditTaskAssembler.swift
//  ToDoList
//
//  Created by Admin on 8/31/24.
//

import Foundation

enum EditTaskAssembler {
    static func assemble(taskId: Int?, state: TaskState, count: Int) -> EditTaskVC{
        let coreData = CoreService()
        
        let vm = EditTaskVM.init(taskId: taskId,
                                 state: state,
                                 coreService: coreData,
                                 count: count)
        let view = EditTaskVC(vm: vm)
        
        return view
    }
}
