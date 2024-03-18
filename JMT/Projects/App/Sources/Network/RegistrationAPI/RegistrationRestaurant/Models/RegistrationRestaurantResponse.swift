//
//  RegistrationRestaurantResponse.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation

struct RegistrationRestaurantResponse: Decodable {
    let data: CreatedRestaurantResponse
    let message: String
    let code: String
}

struct CreatedRestaurantResponse: Decodable {
    let restaurantLocationId: Int
    let recommendRestaurantId: Int
}
