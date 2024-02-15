//
//  UserInfoAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation
import Alamofire

struct UserInfoAPI {
    
    static func getLoginInfo(completion: @escaping (Result<UserInfoModel,NetworkError>) -> ()) {
        
        AF.request(UserInfoTarget.getUserInfo, interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserInfoResponse<UserInfoData>.self) { response in
                
                print("상태코드 ",response.response?.statusCode)
                
                switch response.result {
                case .success(let response):
                    print(response.data)
                    completion(.success(response.toDomain))
                case .failure(let error):
                    print("getLoginInfo 실패!!", error)
                }
            }
    }
}
