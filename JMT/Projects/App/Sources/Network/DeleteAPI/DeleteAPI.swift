//
//  DeleteAPI.swift
//  JMTeng
//
//  Created by PKW on 3/27/24.
//

import Foundation
import Alamofire

struct DeleteAPI {
    static func deleteRestaurantAsync(request: DeleteRestaurantRequest) async throws -> DeleteRestaurantResponse {
        let response = try await AF.request(DeleteTarget.deleteRestauran(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(DeleteRestaurantResponse.self)
            .value
        return response
    }
}
