//
//  UserRestaurantsRequest.swift
//  JMTeng
//
//  Created by 이지훈 on 3/27/24.
//

import Foundation

struct OtherUserRestaurantsRequest: Encodable {
    let parameters: OtherUserRestaurantsPageRequest
    let body: OtherUserRestaurantsRequestBody
}

struct OtherUserRestaurantsPageRequest: Encodable {
    let userId: Int
    let page: Int
    let size: Int
    let sort: String?
}

struct OtherUserRestaurantsRequestBody: Encodable {
    let userLocation: LocationRequest?
    let filter: FilterRequest?
}
