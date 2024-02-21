//
//  SearchRestaurantsLocationResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/02/20.
//

import Foundation

struct SearchRestaurantsLocationResponse: Decodable {
    let data: [RestaurantsLocationData]
    let message: String
    let code: String
}

struct RestaurantsLocationData: Decodable {
    let placeName: String
    let distance: String
    let addressName: String
    let id: String
    let x: String
    let y: String
}

extension SearchRestaurantsLocationResponse {
    var toDomain: [SearchRestaurantsLocationModel] {
        return data.map { locationData in
            SearchRestaurantsLocationModel(
                placeName: locationData.placeName,
                distance: locationData.distance,
                addressName: locationData.addressName,
                subID: locationData.id,
                x: Double(locationData.x) ?? 0.0,
                y: Double(locationData.y) ?? 0.0
            )
        }
    }
}
