//
//  SearchGroupResponse.swift
//  JMTeng
//
//  Created by PKW on 3/15/24.
//

import Foundation

struct SearchGroupResponse: Decodable {
    let data: SearchGroupData
    let message: String
    let code: String
}

struct SearchGroupData: Decodable {
    let groupList: [SearchGroupItems]
    let page: SearchGroupPage
}

struct SearchGroupItems: Decodable {
    let groupId: Int
    let groupName: String
    let groupProfileImageUrl: String?
    let groupIntroduce: String
    let memberCnt: Int
    let restaurantCnt: Int
}

struct SearchGroupPage: Decodable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
    let pageFirst: Bool
    let pageLast: Bool
}

