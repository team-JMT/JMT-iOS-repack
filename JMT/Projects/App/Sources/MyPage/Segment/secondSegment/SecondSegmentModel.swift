//
//  SecondSegmentModel.swift
//  JMTeng
//
//  Created by 이지훈 on 3/17/24.
//

import Foundation

struct ReviewResponse: Codable {
    let data: ReviewData
    let message: String
    let code: String
}

struct ReviewData: Codable {
    let reviewList: [Review]
    let page: PaginationInfo
}

struct Review: Codable {
    let reviewId: Int
    let recommendRestaurantId: Int
    let userName: String
    let reviewContent: String
    let reviewImages: [String]
    let reviewerImageUrl: String
    let groupId: Int
    let groupName: String
}

struct PaginationInfo: Codable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let isEmpty: Bool
    let isPageLast: Bool
    let isPageFirst: Bool

    enum CodingKeys: String, CodingKey {
        case totalPages, currentPage, totalElements, size, numberOfElements, isEmpty = "empty", isPageLast = "pageLast", isPageFirst = "pageFirst"
    }
}
