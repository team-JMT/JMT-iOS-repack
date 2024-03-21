//
//  SearchMapRestaurantModel.swift
//  JMTeng
//
//  Created by PKW on 3/6/24.
//

import Foundation

struct SearchMapRestaurantModel {
    let id: Int
    let name: String
    let restaurantImageUrl: String?
    let introduce: String
    let category: String
    let x: Double
    let y: Double
    let userNickName: String?
    let userProfileImageUrl: String?
    let canDrinkLiquor: Bool
    var reviews: [RestaurantReviewModel]
}
