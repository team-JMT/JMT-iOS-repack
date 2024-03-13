//
//  GroupResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/02/28.
//

import Foundation

struct MyGroupResponse: Decodable {
    let data: [MyGroupData]
    let message: String
    let code: String
}

struct MyGroupData: Decodable {
    let groupId: Int
    let groupName: String
    let groupIntroduce: String
    let groupProfileImageUrl: String?
    let groupBackgroundImageUrl: String?
    let privateGroup: Bool
    var isSelected: Bool
}




