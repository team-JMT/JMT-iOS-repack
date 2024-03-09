//
//  RegistrationRestaurantAPI.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation
import Alamofire

struct RegistrationRestaurantAPI {
    static func registrationRestaurantLocation(request: RegistrationRestaurantLocationRequest) async throws -> RegistrationRestaurantLocationResponse {
        
        let response = try await AF.request(RegistrationRestaurantTarget.registrationRestaurantLocation(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(RegistrationRestaurantLocationResponse.self)
            .value
        return response
    }
    
    
    
    
}
