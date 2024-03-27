//
//  UserRestaurantsRequest.swift
//  JMTeng
//
//  Created by 이지훈 on 3/27/24.
//

import Foundation

struct UserRestaurantsRequest: Encodable {
    let parameters: UserRestaurantsPageRequest
    let body: UserRestaurantsRequestBody
}

struct UserRestaurantsPageRequest: Encodable {
    let userId: Int
    let page: Int
    let size: Int
    let sort: String?
}

struct UserRestaurantsRequestBody: Encodable {
    let userLocation: UserRestaurantsLocation
    let filter: UserRestaurantFilter?
}

struct UserRestaurantsLocation: Encodable {
    let x: String
    let y: String
}

struct UserRestaurantFilter: Encodable {
    let categoryFilter: String?
    let isCanDrinkLiquor: Bool?
}
