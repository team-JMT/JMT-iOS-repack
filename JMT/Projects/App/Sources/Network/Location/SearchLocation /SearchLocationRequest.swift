//
//  SearchLocationRequest.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation

struct SearchLocationRequest: Encodable {
    let query: String
    let page: Int
}
