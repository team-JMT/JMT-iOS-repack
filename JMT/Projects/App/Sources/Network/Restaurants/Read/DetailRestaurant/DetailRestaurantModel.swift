//
//  DetailRestaurantModel.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation

struct DetailRestaurantModel {
    let name: String
    let placeUrl: String
    var category: String
    let phone: String
    let address: String
    let roadAddress: String
    let x: Double
    let y: Double
    var introduce: String
    var canDrinkLiquor: Bool
    var goWellWithLiquor: String
    var recommendMenu: [String]
    let pictures: [String]
    let userId: Int
    let userNickName: String
    let userProfileImageUrl: String
    let differenceInDistance: String
    var reviews: [RestaurantReviewsModel]
    var reviewImageTotalCount: Int
}
