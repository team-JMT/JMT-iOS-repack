//
//  GroupResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/02/28.
//

import Foundation

struct GroupResponse: Decodable {
    let data: [GroupData]
    let message: String
    let code: String
}

struct GroupData: Decodable {
    let groupId: Int
    let groupName: String
    let groupIntroduce: String
    let groupProfileImageUrl: String
    let groupBackgroundImageUrl: String
    let privateGroup: Bool
}




