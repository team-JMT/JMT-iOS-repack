//
//  SocialLoginCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/20.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

protocol SocialLoginCoordinator: Coordinator {
    func setNicknameCoordinator()
    func showNicknameViewController()
    
    func setProfileCoordinator()
    func showProfileViewController()
    
    func showGoogleLoginViewController(completion: @escaping (Result<String,NetworkError>) -> ())
    func showAppleLoginViewController()
    
    var onAppleLoginSuccess: ((Result<String,NetworkError>) -> ())? { get set }
}

class DefaultSocialLoginCoordinator: NSObject, SocialLoginCoordinator {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .socialLogin
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator,
         finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    // 애플 로그인 콜백
    var onAppleLoginSuccess: ((Result<String,NetworkError>) -> ())?
    
    func start() {
        let initialViewController = SocialLoginViewController.instantiateFromStoryboard(storyboardName: "Login") as SocialLoginViewController
        initialViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(initialViewController, animated: true)
    }
    
    func setNicknameCoordinator() {
        let coordinator = DefaultNicknameCoordinator(navigationController: navigationController,
                                                     parentCoordinator: self,
                                                     finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showNicknameViewController() {
        if getChildCoordinator(.nickname) == nil {
            setNicknameCoordinator()
        }
        
        let nicknameCoordinator = getChildCoordinator(.nickname) as! NicknameCoordinator
        nicknameCoordinator.start()
    }
    
    func setProfileCoordinator() {
        let coordinator = DefaultProfileImageCoordinator(navigationController: navigationController,
                                                         parentCoordinator: self,
                                                         finishDelegate: self)
        
        childCoordinators.append(coordinator)
    }
    
    func showProfileViewController() {
        if getChildCoordinator(.profileImage) == nil {
            setProfileCoordinator()
        }
        
        let coordinator = getChildCoordinator(.profileImage) as! ProfileImageCoordinator
        coordinator.start()
    }
    
    func showGoogleLoginViewController(completion: @escaping (Result<String, NetworkError>) -> ()) {
        GIDSignIn.sharedInstance.signIn(withPresenting: navigationController!) { [weak self] signInResult, error in
      
            if let error = error {
                completion(.failure(.googleLoginError))
                return
            }
            
            guard let idToken = signInResult?.user.idToken?.tokenString else {
                completion(.failure(.idTokenError))
                print(1)
                return
            }
            
            completion(.success(idToken))
            print(idToken)
        }
    }
    
    func showAppleLoginViewController() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .nickname:
            childCoordinator = childCoordinators.first(where: { $0 is NicknameCoordinator })
        case .profileImage:
            childCoordinator = childCoordinators.first(where: { $0 is ProfileImageCoordinator })
        default:
            break
        }
        return childCoordinator
    }
}

extension DefaultSocialLoginCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

extension DefaultSocialLoginCoordinator: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.navigationController!.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
             
                self.onAppleLoginSuccess?(.success(identifyTokenString))
            }
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
