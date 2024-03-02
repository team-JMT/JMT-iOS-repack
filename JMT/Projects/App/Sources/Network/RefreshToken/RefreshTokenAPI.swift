//
//  RefreshTokenAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation
import Alamofire

struct RefreshTokenAPI {
    static func refreshToken(request: RefreshTokenRequest, completion: @escaping (Result<RefreshTokenModel, NetworkError>) -> ()) {
    
        AF.request(RefreshTokenTarget.refreshToken(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshTokenResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response.toDomain))
                case .failure(let error):
                    print("refreshToken 실패!!", error)
                    completion(.failure(.custom("refreshToken Error")))
                }
            }
    }
}
