//
//  DetailRestaurantRequest.swift
//  JMTeng
//
//  Created by PKW on 3/5/24.
//

import Foundation
 
struct DetailRestaurantRequest: Encodable {
    let recommendRestaurantId: Int
    let coordinator: DetailRestaurantCoordinate
}

struct DetailRestaurantCoordinate: Encodable {
    let x: String
    let y: String
}


