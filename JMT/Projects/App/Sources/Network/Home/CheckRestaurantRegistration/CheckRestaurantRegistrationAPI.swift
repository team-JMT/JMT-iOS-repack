//
//  CheckRestaurantRegistrationAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/02/22.
//

import Foundation
import Alamofire

struct CheckRestaurantRegistrationAPI {
    static func checkRestaurantRegistration(request: CheckRestaurantRegistrationRequest, completion: @escaping (Result<CheckRestaurantRegistrationModel, NetworkError>) -> ()) {
        
        AF.request(CheckRestaurantRegistrationTarget.checkRestaurantRegistration(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<500)
            .responseDecodable(of: CheckRestaurantRegistrationResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.toDomain))
                case .failure(let error):
                    completion(.failure(.custom("checkRestaurantRegistration Error")))
                }
            }
    }
}
