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

extension UIViewController {
    
    enum AlertType {
        case location
        case photo
    }

    func showAccessDeniedAlert(type: AlertType) {
        
        var title: String?
        var message: String?
        
        switch type {
        case .location:
            title = "위치 서비스 권한 거부됨"
            message = "위치 서비스를 사용하려면 설정에서 권한을 허용해주세요."
        case .photo:
            title = ""
            message = "사진 기능을 사용하려면 '사진/비디오' 접근권한을 허용해야 합니다."
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
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


