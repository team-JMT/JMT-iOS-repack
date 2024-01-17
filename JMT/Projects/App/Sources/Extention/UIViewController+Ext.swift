//
//  UIViewController+Ext.swift
//  App
//
//  Created by PKW on 2023/12/20.
//

import UIKit
import SwinjectStoryboard

// 스토리보드
extension UIViewController {
    static func instantiateFromStoryboard<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: DependencyInjector.shared.container)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
    }
}

// 네비게이션 컨트롤러 백버튼
extension UIViewController {
    func setCustomBackButton() {
        // 커스텀 백 버튼 생성
        let backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(customBackAction))
        
        backButton.tintColor = .black
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // 네비게이션 아이템에 백 버튼 설정
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func customBackAction() {
        // 여기에 백 버튼이 눌렸을 때의 동작 구현
        // 예: 네비게이션 컨트롤러를 통해 이전 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
    }
}

// 키보드 활성화, 비활성화
extension UIViewController {
    
    private struct KeyboardState {
        static var isKeyboardVisible = false
    }
    
    // 키보드 노티 등록
    func registerForKeyboardNotifications(view: UIView, constraint: NSLayoutConstraint) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { noti in
            self.keyboardWillShow(notification: noti, view: view, constraint: constraint)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { noti in
            self.keyboardWillHide(notification: noti, view: view, constraint: constraint)
        }
    }
    
    func keyboardWillShow(notification: Notification, view: UIView, constraint: NSLayoutConstraint) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if KeyboardState.isKeyboardVisible {
                constraint.constant = keyboardHeight
            } else {
                UIView.animate(withDuration: 1) {
                    constraint.constant = keyboardHeight
                    self.view.layoutIfNeeded()
                }
                
                KeyboardState.isKeyboardVisible = true
            }
        }
    }
    
    func keyboardWillHide(notification: Notification, view: UIView, constraint: NSLayoutConstraint) {
        
        UIView.animate(withDuration: 1) {
            constraint.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            KeyboardState.isKeyboardVisible = false
        }
        
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//        }
    }
    
    
    // 키보드 노티 해제
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
