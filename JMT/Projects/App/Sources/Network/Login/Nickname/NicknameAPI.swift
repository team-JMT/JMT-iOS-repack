//
//  NicknameAPI.swift
//  App
//
//  Created by PKW on 2024/01/03.
//

import Foundation
import Alamofire

struct NicknameAPI {
    static func checkDuplicate(request: NicknameRequest, completion: @escaping (Result<String, NetworkError>) -> ()) {
        
        AF.request(NicknameTarget.checkDuplicate(request))
            .validate(statusCode: 200..<500)
            .responseDecodable(of: NicknameResponse<String>.self) { response in
                
                switch response.result {
                case .success(let response):
                    completion(.success(response.code))
                case .failure(let error):
                    print("checkDuplicate 실패!!", error)
                }
            }
    }
    
    static func saveNickname(request: NicknameRequest, completion: @escaping (Result<String, NetworkError>) -> ()) {
        AF.request(NicknameTarget.saveNickname(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NicknameResponse<NicknameData>.self) { response in
                
                switch response.result {
                case .success(let response):
                    completion(.success(response.code))
                case .failure(let error):
                    print("saveNickname 실패!!", error)
                }
            }
    }
}
