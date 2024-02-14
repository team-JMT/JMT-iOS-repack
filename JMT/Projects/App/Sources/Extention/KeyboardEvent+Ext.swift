//
//  KeyboardEvent.swift
//  JMTeng
//
//  Created by PKW on 2024/02/08.
//

import Foundation
import UIKit


protocol KeyboardEvent where Self: UIViewController {
    var transformView: UIView { get }
    func setupKeyboardEvent(keyboardWillShow: @escaping (Notification) -> Void, keyboardWillHide: @escaping (Notification) -> Void)
}

extension KeyboardEvent where Self: UIViewController {
    func setupKeyboardEvent(keyboardWillShow: @escaping (Notification) -> Void, keyboardWillHide: @escaping (Notification) -> Void) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { notification in
            keyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { notification in
            keyboardWillHide(notification)
        }
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
