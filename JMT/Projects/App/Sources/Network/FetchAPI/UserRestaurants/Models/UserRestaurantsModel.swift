//
//  UserRestaurantsModel.swift
//  JMTeng
//
//  Created by 이지훈 on 3/27/24.
//

import Foundation

struct UserRestaurantsModel {
    let items: [UserRestaurantItemsModel]
    let totalCount: Int
}

struct UserRestaurantItemsModel {
    let id: Int
    let name: String
    let restaurantImageUrl: String?
    let category: String
    let userNickName: String
    let userProfileImageUrl: String?
    let groupName: String
}

