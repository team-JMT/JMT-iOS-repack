//
//  SearchMapRestaurantRequest.swift
//  JMTeng
//
//  Created by PKW on 3/6/24.
//

import Foundation

struct RestaurantListRequest: Encodable {
    let parameters: PageRequest
    let body: RestaurantListRequestBody
}

struct RestaurantListRequestBody: Encodable {
    let userLocation: LocationRequest?
    let startLocation: LocationRequest?
    let endLocation: LocationRequest?
    let filter: FilterRequest?
    let groupId: Int
}



