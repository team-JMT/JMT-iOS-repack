//
//  SegmentModel.swift
//  JMTeng
//
//  Created by 이지훈 on 3/5/24.
//

import Foundation

// Define model to parse JSON response
struct RestaurantResponse: Decodable {
    let data: RestaurantData
}

struct RestaurantData: Decodable {
    let restaurants: [Restaurant]
    // Add other properties from "data" object if needed
}
struct Restaurant: Codable {
    let id: Int
    let name, placeUrl, phone, address: String
    let roadAddress, restaurantImageUrl, introduce, category: String
    let userNickName, userProfileImageUrl: String
    let canDrinkLiquor: Bool
    let differenceInDistance: String
}
