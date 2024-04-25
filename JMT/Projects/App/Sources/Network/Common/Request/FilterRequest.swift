//
//  FilterRequest.swift
//  JMTeng
//
//  Created by PKW on 4/24/24.
//

import Foundation

struct FilterRequest: Encodable {
    let categoryFilter: String?
    let isCanDrinkLiquor: Bool?
}
