//
//  CurrentLocationResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/02/12.
//

import Foundation

struct CurrentLocationResponse: Decodable {
    let data: CurrentLocationData
    let message: String
    let code: String
}

struct CurrentLocationData: Decodable {
    let address: String
    let roadAddress: String
}


extension CurrentLocationResponse {
    var toDomain: CurrentLocationModel {
        return CurrentLocationModel(address: data.address, roadAddress: data.roadAddress)
    }
}
