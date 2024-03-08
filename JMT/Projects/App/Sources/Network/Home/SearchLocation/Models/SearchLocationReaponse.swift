//
//  SearchLocationReaponse.swift
//  JMTeng
//
//  Created by PKW on 2024/01/22.
//

import Foundation

struct SearchLocationResponse: Decodable {
    let data: [LocationData]
    let message: String
    let code: String
}

struct LocationData: Decodable {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
}

extension SearchLocationResponse {
    var toDomain: [SearchLocationModel] {
        return data.map { locationData in
            SearchLocationModel(
                placeName: locationData.placeName,
                addressName: locationData.addressName,
                roadAddressName: locationData.roadAddressName,
                x: Double(locationData.x) ?? 0.0,
                y: Double(locationData.y) ?? 0.0
            )
        }
    }
}
