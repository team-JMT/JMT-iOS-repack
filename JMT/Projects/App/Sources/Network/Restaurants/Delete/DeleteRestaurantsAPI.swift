//
//  DeleteRestaurantsAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

struct DeleteRestaurantsAPI {
    // 맛집 삭제하기
    static func deleteRestaurantAsync(request: DeleteRestaurantRequest) async throws -> DeleteRestaurantResponse {
        let response = try await AF.request(DeleteRestaurantsTarget.deleteRestaurant(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(DeleteRestaurantResponse.self)
            .value
        return response
    }
}
