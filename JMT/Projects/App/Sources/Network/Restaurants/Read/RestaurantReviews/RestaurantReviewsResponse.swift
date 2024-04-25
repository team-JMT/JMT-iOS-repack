//
//  GroupRestaurantsInfoReviewResponse.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation

struct RestaurantReviewsResponse: Decodable {
    let data: FindRestaurantReviewsResponse
    let message: String
    let code: String
}

struct FindRestaurantReviewsResponse: Decodable {
    let reviewList: [FindRestaurantReviewsData]
    let page: ReviewPageResponse
}

struct FindRestaurantReviewsData: Decodable {
    let reviewId: Int
    let recommendRestaurantId: Int
    let userName: String
    let reviewContent: String
    let reviewImages: [String]
    let reviewerImageUrl: String?
}

struct ReviewPageResponse: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageFirst: Bool
    let pageLast: Bool
}

extension RestaurantReviewsResponse {
    var toDomain: [RestaurantReviewsModel] {
        return data.reviewList.map { review in
            RestaurantReviewsModel(
                reviewId: review.reviewId,
                recommendRestaurantId: review.recommendRestaurantId,
                userName: review.userName,
                reviewContent: review.reviewContent,
                reviewImages: review.reviewImages,
                reviewerImageUrl: review.reviewerImageUrl,
                totalCount: data.page.totalElements)
        }
    }
}
