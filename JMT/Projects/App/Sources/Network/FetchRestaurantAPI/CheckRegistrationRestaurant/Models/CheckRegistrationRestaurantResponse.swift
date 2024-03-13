//
//  CheckRestaurantRegistrationResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/02/22.
//

import Foundation

struct CheckRegistrationRestaurantResponse: Decodable {
    let data: Bool?
    let message: String
    let code: String
}


extension CheckRegistrationRestaurantResponse {
//    var toDomain: CheckRestaurantRegistrationModel {
//        return CheckRestaurantRegistrationModel(data: data)
//    }
}
