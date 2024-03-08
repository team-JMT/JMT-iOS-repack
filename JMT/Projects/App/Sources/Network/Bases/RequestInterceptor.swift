//
//  RequestInterceptor.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation
import Alamofire
import UIKit

class DefaultRequestInterceptor: RequestInterceptor {
    
    // 리퀘스트 요청시 호출됨
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("어뎁트 호출")
        
        guard urlRequest.url?.absoluteString.hasPrefix("https://api.jmt-matzip.dev/api/v1") == true,
              let accessToken = DefaultKeychainService.shared.accessToken else {
            completion(.success(urlRequest))
            return
        }
        
        var resultUrlRequest = urlRequest
        resultUrlRequest.headers.add(.authorization(bearerToken: accessToken))
        
        print(resultUrlRequest.headers)
        
        completion(.success(resultUrlRequest))
    }
    
    // adapt 후 실패할경우 401 상태코드일경우
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("retry 호출", (request.task?.response as? HTTPURLResponse)?.statusCode)

        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let accessToken = DefaultKeychainService.shared.accessToken ?? ""
        let refreshToken = DefaultKeychainService.shared.refreshToken ?? ""
    
        RefreshTokenAPI.refreshToken(request: RefreshTokenRequest(accessToken: accessToken, refreshToken: refreshToken)) { response in
            switch response {
            case .success(let response):
                
                DefaultKeychainService.shared.accessToken = response.accessToken
                DefaultKeychainService.shared.refreshToken = response.refreshToken
                DefaultKeychainService.shared.accessTokenExpiresIn = response.accessTokenExpiresIn
                
                completion(.retry)
            case .failure(let error):
                print("retry - RefreshTokenAPI.refreshToken 실패", error)
             
                SocialLoginAPI.logout { response in
                    switch response {
                    case .success(let success):

                        guard let windowScene = UIApplication.shared
                            .connectedScenes
                            .filter({ $0.activationState == .foregroundActive })
                            .first as? UIWindowScene else {
                                return
                        }
                        
                        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                            return
                        }
                        
                        DefaultKeychainService.shared.accessToken = nil
                        DefaultKeychainService.shared.refreshToken = nil
                        DefaultKeychainService.shared.accessTokenExpiresIn = nil
                        
                        let appCoordinator = sceneDelegate.appCoordinator
                        appCoordinator?.logout()

                    case .failure(let failure):
                        print("SocialLoginAPI.logout Error")
                    }

                    completion(.doNotRetryWithError(error))
                }
            }
        }
    }
}
