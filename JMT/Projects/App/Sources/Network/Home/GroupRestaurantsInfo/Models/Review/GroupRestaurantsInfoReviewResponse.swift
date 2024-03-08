//
//  GroupRestaurantsInfoReviewResponse.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation

struct GroupRestaurantsInfoReviewResponse: Decodable {
    let data: FindRestaurantReviewResponse
    let message: String
    let code: String
}

struct FindRestaurantReviewResponse: Decodable {
    let reviewList: [FindRestaurantReview]
    let page: PageResponse
}

struct FindRestaurantReview: Decodable {
    let reviewId: Int
    let recommendRestaurantId: Int
    let userName: String
    let reviewContent: String
    let reviewImages: [String]
    let reviewerImageUrl: String
}

struct PageResponse: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageFirst: Bool
    let pageLast: Bool
}
