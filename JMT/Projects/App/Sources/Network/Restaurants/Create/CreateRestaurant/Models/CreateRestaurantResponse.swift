//
//  RegistrationRestaurantResponse.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation

struct CreateRestaurantResponse: Decodable {
    let data: restaurantLocationData
    let message: String
    let code: String
}

struct restaurantLocationData: Decodable {
    let restaurantLocationId: Int
    let recommendRestaurantId: Int
}
