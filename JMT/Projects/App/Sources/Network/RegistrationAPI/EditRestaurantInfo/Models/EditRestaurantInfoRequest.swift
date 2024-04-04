//
//  EditRestaurantInfoRequest.swift
//  JMTeng
//
//  Created by PKW on 4/4/24.
//

import Foundation

struct EditRestaurantInfoRequest: Encodable {
    let id: Int
    let introduce: String
    let categoryId: Int
    let canDrinkLiquor: Bool
    let goWellWithLiquor: String
    let recommendMenu: String
}
