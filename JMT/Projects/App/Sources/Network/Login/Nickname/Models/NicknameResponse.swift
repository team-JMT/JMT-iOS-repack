//
//  NicknameResponse.swift
//  App
//
//  Created by PKW on 2024/01/03.
//

import Foundation

struct NicknameResponse<T: Decodable>: Decodable {
    let data: T?
    let message: String
    let code: String
}

struct NicknameData: Decodable {
    let email: String
    let nickname: String
}

extension NicknameResponse {
    var toDomain: NicknameModel {
        return NicknameModel(code: code)
    }
}
