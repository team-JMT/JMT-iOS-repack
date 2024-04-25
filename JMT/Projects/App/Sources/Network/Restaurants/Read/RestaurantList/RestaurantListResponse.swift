//
//  RestaurantListResponse.swift
//  JMTeng
//
//  Created by PKW on 3/6/24.
//

import Foundation

struct RestaurantListResponse: Decodable {
    let data: RestaurantListData
    let message: String
    let code: String
}
 
struct RestaurantListData: Decodable {
    let restaurants: [RestaurantListItems]
    let page: RestaurantListPage
}

struct RestaurantListItems: Decodable {
    let id: Int
    let name: String
    let placeUrl: String
    let phone: String
    let address: String
    let roadAddress: String
    let x: Double
    let y: Double
    let restaurantImageUrl: String?
    let introduce: String
    let category: String
    let userNickName: String?
    let userProfileImageUrl: String?
    let canDrinkLiquor: Bool
    let differenceInDistance: String
}

struct RestaurantListPage: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageFirst: Bool
    let pageLast: Bool
}

extension RestaurantListResponse {
    var toDomain: [RestaurantListModel] {
        return data.restaurants.map { restaurant in
            RestaurantListModel(id: restaurant.id,
                                name: restaurant.name,
                                restaurantImageUrl: restaurant.restaurantImageUrl,
                                introduce: restaurant.introduce,
                                category: restaurant.category,
                                x: restaurant.x,
                                y: restaurant.y,
                                userNickName: restaurant.userNickName,
                                userProfileImageUrl: restaurant.userProfileImageUrl,
                                canDrinkLiquor: restaurant.canDrinkLiquor,
                                reviews: [])
        }
    }
}
