//
//  SearchRestaurantsLocationAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/02/20.
//

import Foundation
import Alamofire

struct SearchRestaurantsLocationAPI {
    static func getSearchRestaurantsLocation(request: SearchRestaurantsLocationRequest, completion: @escaping (Result<[SearchRestaurantsLocationModel], NetworkError>) -> ()) {
        
        AF.request(SearchRestaurantsLocationTarget.getRestaurantsLocationData(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchRestaurantsLocationResponse.self) { response in
               
                switch response.result {
                case .success(let response):
                    completion(.success(response.toDomain))
                case .failure(let error):
                    print(error)
                }
            }
    }
}
