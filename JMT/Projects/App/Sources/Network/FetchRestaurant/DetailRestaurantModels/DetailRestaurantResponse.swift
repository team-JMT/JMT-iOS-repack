//
//  DetailRestaurantResponse.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation

struct DetailRestaurantResponse: Decodable {
    let data: DetailRestaurantData
    let message: String
    let code: String
}

struct DetailRestaurantData: Decodable {
    let name: String
    let placeUrl: String
    let category: String
    let phone: String
    let address: String
    let roadAddress: String
    let x: Double
    let y: Double
    let introduce: String
    let canDrinkLiquor: Bool
    let goWellWithLiquor: String
    let recommendMenu: String
    let pictures: [String]
    let userId: Int
    let userNickName: String
    let userProfileImageUrl: String
    let differenceInDistance: String
}
