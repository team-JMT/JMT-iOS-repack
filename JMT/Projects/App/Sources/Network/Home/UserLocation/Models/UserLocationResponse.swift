//
//  UserLocationResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/01/20.
//

import Foundation

struct UserLocationResponse: Decodable {
    let data: String?
    let message: String
    let code: String
}

extension UserLocationResponse {
    var toDomain: UserLocationModel {
        return UserLocationModel(message: message, code: code)
    }
}
