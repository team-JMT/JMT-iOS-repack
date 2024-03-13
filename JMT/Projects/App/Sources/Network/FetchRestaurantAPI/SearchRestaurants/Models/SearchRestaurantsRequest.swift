//
//  SearchRestaurantsRequest.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import Foundation

struct SearchRestaurantsRequest: Encodable {
    let keyword: String?
    let x: String?
    let y: String?
}

