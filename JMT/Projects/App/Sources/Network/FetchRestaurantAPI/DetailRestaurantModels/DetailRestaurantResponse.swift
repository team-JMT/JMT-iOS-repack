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

extension DetailRestaurantResponse {
    var toDomain: DetailRestaurantModel {
        return DetailRestaurantModel(
            name: data.name,
            placeUrl: data.placeUrl,
            category: data.category,
            phone: data.phone,
            address: data.address,
            roadAddress: data.roadAddress,
            x: data.x,
            y: data.y,
            introduce: data.introduce,
            canDrinkLiquor: data.canDrinkLiquor,
            goWellWithLiquor: data.goWellWithLiquor,
            recommendMenu: data.recommendMenu.splitByHashTag(),
            pictures: data.pictures,
            userId: data.userId,
            userNickName: data.userNickName,
            userProfileImageUrl: data.userProfileImageUrl,
            differenceInDistance: data.differenceInDistance,
            reviews: [])
    }
}
