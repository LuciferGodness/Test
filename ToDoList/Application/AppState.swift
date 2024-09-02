//
//  AppState.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

final class AppState {
    static var current = AppState()
    
    @UserDefault(key: UserDefaultKeys.isFirstRun.rawValue, defaultValue: false) var isFirstRun: Bool
    @UserDefault(key: UserDefaultKeys.lastTaskId.rawValue, defaultValue: 30) var lastTaskId: Int
}
