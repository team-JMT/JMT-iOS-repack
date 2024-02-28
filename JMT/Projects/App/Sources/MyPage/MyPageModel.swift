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
