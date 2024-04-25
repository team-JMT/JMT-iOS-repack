//
//  DeleteRestaurantResponse.swift
//  JMTeng
//
//  Created by PKW on 3/27/24.
//

import Foundation

struct DeleteRestaurantResponse: Decodable {
    let data: String?
    let message: String
    let code: String
}
