//
//  ReadRestaurantsAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

struct ReadRestaurantsAPI {
    // 맛집 리스트 가져오기
    static func fetchRestaurantListAsync(request: RestaurantListRequest) async throws -> RestaurantListResponse {
        let response = try await AF.request(ReadRestaurantsTarget.restaurantsList(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(RestaurantListResponse.self)
            .value
        return response
    }
    
    // 다른 맛집 리스트 가져오기
    static func fetchOutBoundRestaurantsAsync(request: OutBoundRestaurantsRequest) async throws -> OutBoundRestaurantsResponse {
        let response = try await AF.request(ReadRestaurantsTarget.outBoundRestaurants(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(OutBoundRestaurantsResponse.self)
            .value
        return response
    }
    
    // 맛집이 등록되어있는지 체크하기
    static func checkRegistrationRestaurantAsync(request: CheckRegistrationRestaurantRequest) async throws -> CheckRegistrationRestaurantResponse {
        let response = try await AF.request(ReadRestaurantsTarget.checkRegistrationRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(CheckRegistrationRestaurantResponse.self)
            .value
        return response
    }
    
    // 맛집 상세 정보 가져오기
    static func fetchDetailRestaurantAsync(request: DetailRestaurantRequest) async throws -> DetailRestaurantResponse {
        let response = try await AF.request(ReadRestaurantsTarget.detailRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(DetailRestaurantResponse.self)
            .value
        return response
    }
    
    // 다른 유저가 등록한 맛집 가져오기
    static func fetchUserRestaurantsAsync(request: OtherUserRestaurantsRequest) async throws -> OtherUserRestaurantsResponse {
        let response = try await AF.request(ReadRestaurantsTarget.otherUserRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(OtherUserRestaurantsResponse.self)
            .value
        return response
    }
    
    // 맛집 위치 검색하기
    static func searchRestaurantLocationsAsync(request: SearchRestaurantsLocationRequest) async throws -> SearchRestaurantsLocationResponse {
        let response = try await AF.request(ReadRestaurantsTarget.searchRestaurantsLocation(request),
                                            interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchRestaurantsLocationResponse.self)
            .value
        return response
    }
    
    // 맛집 검색하기
    static func searchRestaurantsAsync(request: SearchRestaurantsRequest) async throws -> SearchRestaurantsResponse {
        let response = try await AF.request(ReadRestaurantsTarget.searchRestaurants(request),
                                            interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchRestaurantsResponse.self)
            .value
        return response
    }
    
    // 맛집 리뷰 가져오기
    static func fetchRestaurantReviewsAsync(request: RestaurantReviewsRequest) async throws -> RestaurantReviewsResponse {
        let response = try await AF.request(ReadRestaurantsTarget.restaurantReviews(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(RestaurantReviewsResponse.self)
            .value
        return response
    }
}
