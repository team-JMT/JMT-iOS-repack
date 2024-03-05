//
//  logoutAlertViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 3/4/24.
//

import UIKit
import Alamofire

class logoutAlertViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var KeepView: UIView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        mainView.layer.cornerRadius = 20
        logoutView.layer.cornerRadius = 12
        logoutView.layer.borderColor = UIColor(named: "main500")?.cgColor
        
        logoutView.layer.borderWidth = 2
        
        KeepView.layer.cornerRadius = 12
        
        
        
    }
    
    
    //유지하기
    @objc func dismissView(){
        dismiss(animated: false, completion: nil)
    }
    
    
    // 로그아웃 기능 구현
    func logout(completion: @escaping (Bool) -> Void) {
        let url = "https://api.jmt-matzip.dev/api/v1/auth/user"
        
        // KeychainService에서 액세스 토큰 가져오기
        guard let token = DefaultKeychainService.shared.accessToken else {
            print("Access Token is not available")
            completion(false)
            return
        }
        
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        // KeychainService에서 리프레시 토큰 가져오기
        guard let refreshToken = DefaultKeychainService.shared.refreshToken else {
            print("Refresh Token is not available")
            completion(false)
            return
        }
        
        let parameters = ["refreshToken": refreshToken]
        
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().response { response in
            switch response.result {
            case .success:
                // Keychain에 저장된 토큰 정보 삭제
                DefaultKeychainService.shared.accessToken = nil
                DefaultKeychainService.shared.refreshToken = nil
                DefaultKeychainService.shared.accessTokenExpiresIn = nil
                
                print("Logout successful.")
                completion(true)
            case .failure(let error):
                print("Error during logout: \(error)")
                completion(false)
            }
        }
    }
    
    //로그아웃
    @IBAction func logoutTapped(_ sender: Any) {
        logout { [weak self] success in
                if success {
                    // 로그아웃 성공 시 SignInViewController로 돌아가기
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    if let signInVC = storyboard.instantiateViewController(withIdentifier: "SocialLoginViewController") as? SocialLoginViewController {
                        signInVC.modalPresentationStyle = .fullScreen
                        self?.present(signInVC, animated: true, completion: nil)
                    }
                } else {
                    print("Logout failed.")
                }
            }
        print("1221x")
    }
    
}
