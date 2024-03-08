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

struct RestaurantSearchResponse: Codable {
    let data: RestaurantSearchData
}

struct RestaurantSearchData: Codable {
    let restaurants: [Restaurant]
    let page: Page
}

struct Restaurant: Codable {
    
    
}

struct Page: Codable {
    let totalPages: Int
    let currentPage: Int
    let totalElements: Int
    let size: Int
    let numberOfElements: Int
    let empty: Bool
}
