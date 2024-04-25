//
//  SearchRestaurantsResponse.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import Foundation

struct SearchRestaurantsResponse: Decodable {
    let data: SearchRestaurantsData
    let message: String
    let code: String
}

struct SearchRestaurantsData: Decodable {
    let restaurants: [SearchRestaurantsItems]
    let page: SearchRestaurantsPage
}

struct SearchRestaurantsItems: Decodable {
    let id: Int
    let name: String
    let placeUrl: String
    let phone: String
    let address: String
    let roadAddress: String
    let x: Double
    let y: Double
    let restaurantImageUrl: String
    let introduce: String
    let category: String
    let userNickName: String?
    let userProfileImageUrl: String?
    let canDrinkLiquor: Bool
    let differenceInDistance: String
    let groupId: Int
    let groupName: String
}

struct SearchRestaurantsPage: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageFirst: Bool
    let pageLast: Bool
}
