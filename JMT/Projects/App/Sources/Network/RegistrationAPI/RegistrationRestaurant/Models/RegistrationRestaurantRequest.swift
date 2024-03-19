//
//  RegistrationRestaurantRequest.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation

struct RegistrationRestaurantRequest: Encodable {
    let name: String
    let introduce: String
    let categoryId: Int
    let canDrinkLiquor: Bool
    let goWellWithLiquor: String
    let recommendMenu: String
    let restaurantLocationId: Int
    let groupId: Int
}
