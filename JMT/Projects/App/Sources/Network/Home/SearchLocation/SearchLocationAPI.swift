//
//  SearchLocationAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/01/22.
//

import Foundation
import Alamofire

struct SearchLocationAPI {
    static func getSearchLocations(request: SearchLocationRequest, completion: @escaping (Result<[SearchLocationModel], NetworkError>) -> ()) {
        
        AF.request(SearchLocationTarget.getSearchLocations(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchLocationResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response.toDomain))
                case .failure(let error):
                    print("123123")
                }
            }
    }
}
