//
//  withdrawlAlertViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 3/4/24.
//

import UIKit

class withdrawlAlertViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var withdrawView: UIView!
    
    @IBOutlet weak var KeepView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        mainView.layer.cornerRadius = 20
        withdrawView.layer.cornerRadius = 12
        withdrawView.layer.borderColor = UIColor(named: "main500")?.cgColor
        
        withdrawView.layer.borderWidth = 2
        
        KeepView.layer.cornerRadius = 12
        
        
    }
    
        func withdrawAccount(completion: @escaping (Bool) -> Void) {
            let url = "https://api.jmt-matzip.dev/api/v1/user"
    
            var token: String = "" // Default value for token
            let loginMethod = UserDefaults.standard.string(forKey: "loginMethod")
    
            switch loginMethod {
            case "google":
                token = UserDefaults.standard.string(forKey: "CustomAccessToken") ?? ""
            case "apple":
                token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
            default:
                token = UserDefaults.standard.string(forKey: "CustomAccessToken") ?? ""
                print("Unexpected login method.")
            }
    
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
    
            AF.request(url, method: .delete, headers: headers).validate().response { response in
                print(response)
                switch response.result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Error: \(error)")
                    completion(false)
                }
            }
    
        }
    
        @IBAction func withdrawBtnTapped(_ sender: Any) {
            withdrawAccount { success in
                    if success {
                        print("Withdrawal successful.")
                        UserDefaults.standard.set(false, forKey: "IsWithdrawal") // 플래그
                        let isWithdrawalValue = UserDefaults.standard.bool(forKey: "IsWithdrawal")
                        print("IsWithdrawal value: \(isWithdrawalValue)")
    
                        // 회원 탈퇴 성공 시 모든 저장된 정보 삭제 및 SignInViewController로 돌아가기
                        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
                        UserDefaults.standard.removeObject(forKey: "accessToken")
                        UserDefaults.standard.removeObject(forKey: "refreshToken")
                        UserDefaults.standard.synchronize()
    
                        print("Debug: Access Token after deletion: \(String(describing: UserDefaults.standard.string(forKey: "accessToken")))")
                        print("Debug: Refresh Token after deletion: \(String(describing: UserDefaults.standard.string(forKey: "refreshToken")))")
    
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
                            signInVC.modalPresentationStyle = .fullScreen
                            self.present(signInVC, animated: true, completion: nil)
                        }
    
                    } else {
                        print("Withdrawal failed.")
                    }
                }
        }
    @objc func dismissView(){
        dismiss(animated: false, completion: nil)
    }
    
}


