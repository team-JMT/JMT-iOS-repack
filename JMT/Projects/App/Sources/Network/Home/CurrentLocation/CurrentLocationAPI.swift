//
//  CurrentLocationAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/02/12.
//

import Foundation
import Alamofire

struct CurrentLocationAPI {
    static func getCurrentLocation(request: CurrentLocationRequest, completion: @escaping (Result<CurrentLocationModel, NetworkError>) -> ()) {
        
        AF.request(CurrentLocationTarget.getCurrentLocation(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CurrentLocationResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response.toDomain))
                case .failure(_):
                    completion(.failure(.custom("currentLocation - Error")))
                }
            }
    }
}
