//
//  UITextView + Extension.swift
//  ToDoList
//
//  Created by Admin on 8/31/24.
//

import Foundation
import UIKit

extension UITextView {
    func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.superview?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
