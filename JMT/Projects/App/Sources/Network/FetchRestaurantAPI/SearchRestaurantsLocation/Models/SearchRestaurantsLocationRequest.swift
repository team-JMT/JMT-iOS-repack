//
//  SearchRestaurantsLocationRequest.swift
//  JMTeng
//
//  Created by PKW on 2024/02/20.
//

import Foundation

struct SearchRestaurantsLocationRequest: Encodable {
    let query: String
    let page: Int
    let x: String
    let y: String
}

