//
//  UserRestaurantsResponse.swift
//  JMTeng
//
//  Created by 이지훈 on 3/27/24.
//

import Foundation

struct UserRestaurantsResponse: Decodable {
    let data: UserRestaurantsData
    let message: String
    let code: String
}

struct UserRestaurantsData: Decodable {
    let restaurants: [UserRestaurantItems]
    let page: UserRestaurantsPage
}

struct UserRestaurantItems: Decodable {
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
    let userNickName: String
    let userProfileImageUrl: String?
    let canDrinkLiquor: Bool
    let differenceInDistance: String
    let groupId: Int
    let groupName: String
}

struct UserRestaurantsPage: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageLast: Bool
    let pageFirst: Bool
}

extension UserRestaurantsResponse {
    
    var toDomain: UserRestaurantsModel {
        let restaurants = data.restaurants.map { restaurant in
            UserRestaurantItemsModel(id: restaurant.id,
                                 name: restaurant.name,
                                 restaurantImageUrl: restaurant.restaurantImageUrl,
                                 category: restaurant.category,
                                 userNickName: restaurant.userNickName,
                                 userProfileImageUrl: restaurant.userProfileImageUrl,
                                 groupName: restaurant.groupName)
        }
        
        let result = UserRestaurantsModel(items: restaurants, totalCount: data.page.totalElements)

        return result
    }
}
