//
//  SearchRestaurantsOutBoundResponse.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import Foundation

struct SearchRestaurantsOutBoundResponse: Decodable {
    let data: SearchRestaurantsOutBoundData
    let message: String
    let code: String
}

struct SearchRestaurantsOutBoundData: Decodable {
    let restaurants: [SearchRestaurantsOutBoundItems]
    let page: SearchRestaurantsOutBoundPage
}

struct SearchRestaurantsOutBoundItems: Decodable {
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

struct SearchRestaurantsOutBoundPage: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageFirst: Bool
    let pageLast: Bool
    
}

extension SearchRestaurantsOutBoundResponse {
    var toDomain: [SearchRestaurantsOutBoundModel] {
        return data.restaurants.map { data in
            SearchRestaurantsOutBoundModel(
                id: data.id,
                groupId: data.groupId,
                groupName: data.groupName,
                name: data.name,
                userProfileImageUrl: data.userProfileImageUrl ?? "",
                userNickName: data.userNickName,
                restaurantImageUrl: data.restaurantImageUrl ?? "",
                category: data.category,
                canDrinkLiquor: data.canDrinkLiquor,
                differenceInDistance: data.differenceInDistance)
        }
    }
}
