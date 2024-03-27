//
//  MyPageModel.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import Foundation

struct MyPageUserLogin: Codable {
    let data: UserData?
    let message: String
    let code: String
 
}

struct UserData: Codable {
    let id: Int
    let email, nickname, profileImg: String
}

// MARK: - ResturantResponse
struct ResturantResponse: Codable {
    let data: DataClass?
    let message, code: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let restaurants: [Restaurant]?
    let page: Page?
}

// MARK: - Page
struct Page: Codable {
    let totalPages, currentPage, totalElements, size: Int?
    let numberOfElements: Int?
    let empty, pageLast, pageFirst: Bool?
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: Int?
    let name, placeURL, phone, address: String?
    let roadAddress: String?
    let x, y: Double?
    let restaurantImageURL, introduce, category, userNickName, groupName: String?
    let groupId : Int?
    let userProfileImageURL: String?
    let canDrinkLiquor: Bool?
    let differenceInDistance: String?
    let pictures: [String]? 

}
