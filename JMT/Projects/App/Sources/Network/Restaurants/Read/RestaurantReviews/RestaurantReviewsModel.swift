//
//  GroupRestaurantsInfoReviewModel.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation

struct RestaurantReviewsModel {
    let reviewId: Int
    let recommendRestaurantId: Int
    let userName: String
    let reviewContent: String
    let reviewImages: [String]
    let reviewerImageUrl: String?
    let totalCount: Int
}


