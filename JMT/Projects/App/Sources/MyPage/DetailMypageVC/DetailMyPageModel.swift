//
//  DetailMyPageModel.swift
//  JMTeng
//
//  Created by 이지훈 on 2/28/24.
//

import Foundation

import Alamofire

// MARK: - ImageResponse
struct ImageResponse: Codable {
    let data: String?
    let message, code: String?
}

// MARK: - NicknameRegister
struct NicknameRegister: Codable {
    let data: NicknameClass?
    let message, code: String?
}

// MARK: - DataClass
struct NicknameClass : Codable {
    let email, nickname: String?
}
