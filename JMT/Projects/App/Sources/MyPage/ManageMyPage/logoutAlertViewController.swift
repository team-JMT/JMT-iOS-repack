//
//  logoutAlertViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 3/4/24.
//

import UIKit

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
    
    //
    //    func logout(completion: @escaping (Bool) -> Void) {
    //        let url = "https://api.jmt-matzip.dev/api/v1/user"
    //
    //        var token: String = "" // Default value for token
    //        let loginMethod = UserDefaults.standard.string(forKey: "loginMethod")
    //
    //        switch loginMethod {
    //        case "google":
    //            token = UserDefaults.standard.string(forKey: "CustomAccessToken") ?? ""
    //        case "apple":
    //            token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    //        default:
    //            token = UserDefaults.standard.string(forKey: "CustomAccessToken") ?? ""
    //            print("Unexpected login method.")
    //        }
    //
    //        let headers: HTTPHeaders = [
    //            "accept": "*/*",
    //            "Authorization": "Bearer \(token)",
    //            "Content-Type": "application/json"
    //        ]
    //
    //        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    //        let parameters = ["refreshToken": refreshToken]
    //
    //        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().response { response in
    //            switch response.result {
    //            case .success:
    //                completion(true)
    //            case .failure(let error):
    //                print("Error: \(error)")
    //                completion(false)
    //            }
    //        }
    //    }
    //
    
        @objc func dismissView(){
            dismiss(animated: false, completion: nil)
        }
    
    //
    //
    //    @IBAction func logoutTapped(_ sender: Any) {
    //        logout { success in
    //            if success {
    //
    //                UserDefaults.standard.set(false, forKey: "IsWithdrawal")
    //                let isWithdrawalValue = UserDefaults.standard.bool(forKey: "IsWithdrawal")
    //                print("IsWithdrawal value after logout: \(isWithdrawalValue)")
    //
    //
    //                HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    //                UserDefaults.standard.removeObject(forKey: "accessToken")
    //                UserDefaults.standard.removeObject(forKey: "refreshToken")
    //                UserDefaults.standard.synchronize()
    //                print("Logout successful.")
    //
    //                // 로그아웃 성공 시 SignInViewController로 돌아가기
    //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //                if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
    //                    signInVC.modalPresentationStyle = .fullScreen
    //                    self.present(signInVC, animated: true, completion: nil)
    //                }
    //
    //            } else {
    //                print("Logout failed.")
    //            }
    //
    //        }
    //    }
    //
    //
    //
    //
    //
}
