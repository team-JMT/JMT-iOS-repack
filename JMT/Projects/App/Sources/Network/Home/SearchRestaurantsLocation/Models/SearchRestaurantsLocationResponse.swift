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
    let placeUrl: String
    let categoryName: String
    let addressName: String
    let roadAddressName: String
    let id: String
    let phone: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let x: String
    let y: String
}

extension SearchRestaurantsLocationResponse {
    var toDomain: [SearchRestaurantsLocationModel] {
        return data.map { locationData in
            SearchRestaurantsLocationModel(placeName: locationData.placeName,
                                           distance: Int(locationData.distance) ?? 0,
                                           placeUrl: locationData.placeUrl,
                                           categoryName: locationData.categoryName,
                                           addressName: locationData.addressName,
                                           roadAddressName: locationData.roadAddressName,
                                           id: locationData.id,
                                           phone: locationData.phone,
                                           categoryGroupCode: locationData.categoryGroupCode,
                                           categoryGroupName: locationData.categoryGroupName,
                                           x: Double(locationData.x) ?? 0.0,
                                           y: Double(locationData.y) ?? 0.0
            )
        }
    }
}
