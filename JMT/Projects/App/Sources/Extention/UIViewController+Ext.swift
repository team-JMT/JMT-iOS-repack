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
    func setCustomNavigationBarBackButton(isSearchVC: Bool) {
        
        var backButton = UIBarButtonItem()
        
        // 커스텀 백 버튼 생성
        if isSearchVC {
            backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(goToHomeTab))
        } else {
            backButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(popViewController))
        }
        
        backButton.tintColor = .black
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // 네비게이션 아이템에 백 버튼 설정
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc private func popViewController() {
        // 여기에 백 버튼이 눌렸을 때의 동작 구현
        // 예: 네비게이션 컨트롤러를 통해 이전 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToHomeTab() {
        self.tabBarController?.selectedIndex = 0
    }
}

// 키보드 활성화, 비활성화
extension UIViewController {
    
//    func registerForKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(_ sender: Notification) {
//        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        if let currentResponder = UIResponder.currentResponder {
//            switch currentResponder {
//            case let textField as UITextField:
//                adjustViewForKeyboard(textField: textField, keyboardFrame: keyboardFrame.cgRectValue)
//            case let textView as UITextView:
//                adjustViewForKeyboard(textView: textView, keyboardFrame: keyboardFrame.cgRectValue)
//            case let view as UIView:
//                adjustViewForKeyboard(view: view, keyboardFrame: keyboardFrame.cgRectValue)
//            default:
//                break // 다른 타입의 응답자인 경우 처리하지 않음
//            }
//        }
//    }
//
//    private func adjustViewForKeyboard(textField: UITextField, keyboardFrame: CGRect) {
//        // UITextField에 대한 위치 조정 로직
//        // Y축으로 키보드의 상단 위치
//        let keyboardTopY = keyboardFrame.origin.y
//
//        // 현재 선택한 텍스트 필드의 Frame 값
//        let convertedTextFieldFrame = view.convert(textField.frame, from: textField.superview)
//        // Y축으로 현재 텍스트 필드의 하단 위치
//        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
//
//        if textFieldBottomY > keyboardTopY {
//            let textFieldTopY = convertedTextFieldFrame.origin.y
//            // 노가다를 통해서 모든 기종에 적절한 크기를 설정함.
//            let newFrame = textFieldTopY - keyboardTopY / 1.6
//            view.frame.origin.y -= newFrame
//        }
//    }
//
//    private func adjustViewForKeyboard(textView: UITextView, keyboardFrame: CGRect) {
//        // UITextView에 대한 위치 조정 로직
//        print(textView)
//    }
//
//    private func adjustViewForKeyboard(view: UIView, keyboardFrame: CGRect) {
//        // UITextView에 대한 위치 조정 로직
//        print(view)
//    }
//
//    @objc func keyboardWillHide(_ sender: Notification) {
//        if view.frame.origin.y != 0 {
//            view.frame.origin.y = 0
//        }
//    }
//
//    // 키보드 노티 등록
//    func registerForKeyboardNotifications(view: UIView?, constraint: NSLayoutConstraint?) {
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { noti in
//            self.keyboardWillShow(notification: noti, view: view, constraint: constraint)
//        }
//
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { noti in
//            self.keyboardWillHide(notification: noti, view: view, constraint: constraint)
//        }
//    }
    
//    func keyboardWillShow(notification: Notification, view: UIView?, constraint: NSLayoutConstraint?) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            KeyboardState.keyboardHeight = keyboardHeight
//
//            if KeyboardState.isKeyboardVisible {
//                constraint?.constant = keyboardHeight
//            } else {
//                UIView.animate(withDuration: 1) {
//                    constraint?.constant = keyboardHeight
//                    self.view.layoutIfNeeded()
//                }
//
//                KeyboardState.isKeyboardVisible = true
//            }
//        }
//    }
    
//    func keyboardWillHide(notification: Notification, view: UIView?, constraint: NSLayoutConstraint?) {
//
//        UIView.animate(withDuration: 1) {
//            constraint?.constant = 0
//            self.view.layoutIfNeeded()
//        } completion: { _ in
//            KeyboardState.isKeyboardVisible = false
//        }
//
////        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
////            let keyboardRectangle = keyboardFrame.cgRectValue
////            let keyboardHeight = keyboardRectangle.height
////        }
//    }
    
    
    // 키보드 노티 해제
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showLocationAccessDeniedAlert() {
            let alertController = UIAlertController(
                title: "위치 서비스 권한 거부됨",
                message: "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요.",
                preferredStyle: .alert
            )
            
            let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // 설정 앱이 성공적으로 열린 후의 처리
                    })
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            
            // 현재 뷰 컨트롤러에서 경고 대화 상자 표시
            present(alertController, animated: true, completion: nil)
        }
}


