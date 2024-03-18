//
//  SearchMapRestaurantRequest.swift
//  JMTeng
//
//  Created by PKW on 3/6/24.
//

import Foundation

struct SearchMapRestaurantRequest: Encodable {
    let parameters: SearchMapRestaurantPageRequest
    let body: SearchMapRestaurantRequestBody
}

struct SearchMapRestaurantPageRequest: Encodable {
    let page: Int
    let size: Int
    let sort: String?
}

struct SearchMapRestaurantRequestBody: Encodable {
    let userLocation: SearchMapRestaurantLocation?
    let startLocation: SearchMapRestaurantLocation?
    let endLocation: SearchMapRestaurantLocation?
    let filter: SearchMapRestaurantFilter?
    let groupId: Int
}

struct SearchMapRestaurantLocation: Encodable {
    let x: String
    let y: String
}

struct SearchMapRestaurantFilter: Encodable {
    let categoryFilter: String?
    let isCanDrinkLiquor: Bool?
}

