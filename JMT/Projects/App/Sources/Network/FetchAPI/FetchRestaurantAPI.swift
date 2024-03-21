//
//  FetchRestaurantAPI.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation
import Alamofire

struct FetchRestaurantAPI {
    
    static func fetchSearchMapRestaurantsAsync(request: SearchMapRestaurantRequest) async throws -> SearchMapRestaurantResponse {
        let response = try await AF.request(FetchRestaurantTarget.fetchSearchMapRestaurants(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchMapRestaurantResponse.self)
            .value
        return response
    }

    static func fetchSearchRestaurantLocationsAsync(request: SearchRestaurantsLocationRequest) async throws -> SearchRestaurantsLocationResponse {
        let response = try await AF.request(FetchRestaurantTarget.fetchSearchRestaurantsLocation(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchRestaurantsLocationResponse.self)
            .value
        return response
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
    
    static func fetchRestaurantReviewsAsync(request: RestaurantReviewRequest) async throws -> RestaurantReviewResponse {
        let response = try await AF.request(FetchRestaurantTarget.fetchRestaurantReviews(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(RestaurantReviewResponse.self)
            .value
        return response
    }
    
    static func fetchSearchRestaurantsAsync(request: SearchRestaurantsRequest) async throws -> SearchRestaurantsResponse {
        let response = try await AF.request(FetchRestaurantTarget.fetchSearchRestaurants(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchRestaurantsResponse.self)
            .value
        return response
    }
    
    static func fetchSearchRestaurantsOutBoundAsync(request: SearchRestaurantsOutBoundRequest) async throws -> SearchRestaurantsOutBoundResponse {
        let response = try await AF.request(FetchRestaurantTarget.fetchRestaurantsOutBound(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchRestaurantsOutBoundResponse.self)
            .value
        return response
    }
}


