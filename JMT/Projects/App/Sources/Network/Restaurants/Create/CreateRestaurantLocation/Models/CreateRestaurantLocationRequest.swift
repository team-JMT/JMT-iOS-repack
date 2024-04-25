//
//  RegistrationRestaurantLocationRequest.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation

struct CreateRestaurantLocationRequest: Encodable {
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
