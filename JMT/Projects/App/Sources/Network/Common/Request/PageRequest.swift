//
//  PageRequest.swift
//  JMTeng
//
//  Created by PKW on 4/24/24.
//

import Foundation

struct PageRequest: Encodable {
    let page: Int
    let size: Int
    let sort: String?
}
