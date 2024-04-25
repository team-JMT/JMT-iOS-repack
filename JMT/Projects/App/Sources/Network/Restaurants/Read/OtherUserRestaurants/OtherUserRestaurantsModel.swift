//
//  OtherUserRestaurantsModel.swift
//  JMTeng
//
//  Created by 이지훈 on 3/27/24.
//

import Foundation

struct OtherUserRestaurantsModel {
    let items: [OtherUserRestaurantsModelItems]
    let totalCount: Int
}

struct OtherUserRestaurantsModelItems {
    let id: Int
    let name: String
    let restaurantImageUrl: String?
    let category: String
    let userNickName: String
    let userProfileImageUrl: String?
    let groupName: String
}

