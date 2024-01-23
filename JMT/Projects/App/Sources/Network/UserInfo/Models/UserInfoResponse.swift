//
//  UserInfoResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import Foundation

struct UserInfoResponse<T:Decodable>: Decodable {
    let data: T
    let message: String
    let code: String
}

struct UserInfoData: Decodable {
    let id: Int
    let email: String
    let nickname: String
    let profileImg: String
}

extension UserInfoResponse {
    var toDomain: UserInfoModel {
        let model = data as! UserInfoData
        return UserInfoModel(id: model.id , nickname: model.nickname, profileImg: model.profileImg)
    }
}
