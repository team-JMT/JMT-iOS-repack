//
//  GroupRestaurantsInfoAPI.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation
import Alamofire

struct GroupRestaurantsInfoAPI {
//    static func fetchRestaurantsInfo(request: GroupRestaurantsInfoRequest, completion: @escaping (Result<[FindRestaurantItems], NetworkError>) -> ()) {
//        
//        AF.request(GroupRestaurantsInfoTarget.fetchGroupRestaurantsInfo(request), interceptor: DefaultRequestInterceptor())
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: GroupRestaurantsInfoResponse.self) { response in
//                switch response.result {
//                case .success(let success):
//                    completion(.success(success.data.restaurants))
//                case .failure(let failure):
//                    completion(.failure(.custom("fetchRestaurantsInfo Error")))
//                }
//            }
//    }
    
    static func fetchRestaurantsInfoReview(request: GroupRestaurantsInfoReviewRequest, completion: @escaping (Result<[FindRestaurantReview], NetworkError>) -> ()) {
        
        AF.request(GroupRestaurantsInfoTarget.fetchReviews(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GroupRestaurantsInfoReviewResponse.self) { response in
                switch response.result {
                case .success(let success):
                    completion(.success(success.data.reviewList))
                case .failure(_):
                    completion(.failure(.custom("fetchRestaurantsInfoReview Error")))
                }
            }
    }
}
