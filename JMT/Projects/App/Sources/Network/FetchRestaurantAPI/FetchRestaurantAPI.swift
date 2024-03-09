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
        let response = try await AF.request(FetchRestaurantTarget.fetchSearchMapRestaurants(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchMapRestaurantResponse.self)
            .value
        return response.data.restaurants
    }

    static func fetchSearchRestaurantsAsync(request: SearchRestaurantsRequest) async throws -> [SearchRestaurantsModel] {
        let response = try await AF.request(FetchRestaurantTarget.fetchSearchRestaurants(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchRestaurantsResponse.self)
            .value
        return response.toDomain
    }
    
    static func checkRegistrationRestaurantAsync(request: CheckRegistrationRestaurantRequest) async throws -> CheckRegistrationRestaurantResponse {
        let response = try await AF.request(FetchRestaurantTarget.checkRegistrationRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(CheckRegistrationRestaurantResponse.self)
            .value
        return response
    }
    
    static func fetchDetailRestaurantAsync(request: DetailRestaurantRequest) async throws -> DetailRestaurantResponse {
        let response = try await AF.request(FetchRestaurantTarget.fetchDetailRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(DetailRestaurantResponse.self)
            .value
        return response
    }
}
 

/*
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
 */
