//
//  UpdateRestaurantsAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

struct UpdateRestaurantsAPI {
    // 맛집 정보 수정하기
    static func editRestaurant(request: EditRestaurantRequest) async throws -> EditRestaurantResponse {
        let response = try await AF.request(UpdateRestaurantsTarget.editRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(EditRestaurantResponse.self)
            .value
        return response
    }
}
