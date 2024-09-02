//
//  UserDefault.swift
//  ToDoList
//
//  Created by Admin on 8/28/24.
//

import Foundation

enum UserDefaultKeys: String {
    case isFirstRun
    case lastTaskId
}

@propertyWrapper
final class UserDefault<T: Codable> {
    let key: String
    let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data,
                let user = try? JSONDecoder().decode(T.self, from: data) {
                return user

            }

            return defaultValue
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
                UserDefaults.standard.synchronize()
            }
        }
    }
}
