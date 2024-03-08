//
//  FetchRestaurantAPI.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation
import Alamofire

struct FetchRestaurantAPI {
    
    static func fetchSearchMapRestaurantsAsync(request: SearchMapRestaurantRequest) async throws -> [SearchMapRestaurantItems] {
        
        do {
            let response = try await AF.request(FetchRestaurantTarget.fetchSearchMapRestaurants(request), interceptor: DefaultRequestInterceptor())
                .validate(statusCode: 200..<300)
                .serializingDecodable(SearchMapRestaurantResponse.self)
                .value
            return response.data.restaurants
        } catch {
            print(error)
            throw NetworkError.custom("fetchSearchMapRestaurantsAsync Error")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    static func fetchSearchMapRestaurants(request: SearchMapRestaurantRequest, completion: @escaping (Result<[SearchMapRestaurantItems], NetworkError>) -> ()) {
        
        AF.request(FetchRestaurantTarget.fetchSearchMapRestaurants(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SearchMapRestaurantResponse.self) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result.data.restaurants))
                case .failure(let error):
                    print(error)
                    completion(.failure(.custom("fetchSearchMapRestaurants Error")))
                }
            }
    }
}
 
