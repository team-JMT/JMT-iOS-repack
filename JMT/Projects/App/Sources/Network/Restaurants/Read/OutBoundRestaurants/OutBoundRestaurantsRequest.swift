//
//  SearchRestaurantsOutBoundRequest.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import Foundation

struct OutBoundRestaurantsRequest: Encodable {
    let keyword: String?
    let currentGroupId: Int?
}
