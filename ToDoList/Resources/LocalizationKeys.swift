//
//  LocalizableKeys.swift
//  ToDoList
//
//  Created by Admin on 9/2/24.
//

import Foundation

enum LocalizationKeys: String.LocalizationValue {
    case saveError
    case error
    case fetchError
    case fetchFail
    case ok
    case fillTitle
    case cantUpdate
    case noDescription
    
    var localized: String {
        String(localized: self.rawValue)
    }
}
