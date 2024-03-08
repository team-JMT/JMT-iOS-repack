//
//  CurrentLocationResponse.swift
//  JMTeng
//
//  Created by PKW on 2024/02/12.
//

import Foundation

//struct CurrentLocationResponse: Decodable {
//    let data: CurrentLocationData
//    let message: String
//    let code: String
//}
//
//struct CurrentLocationData: Decodable {
//    let address: String
//    let roadAddress: String
//}
//
//
//extension CurrentLocationResponse {
//    var toDomain: CurrentLocationModel {
//        return CurrentLocationModel(address: data.address, roadAddress: data.roadAddress)
//    }
//}

struct CurrentLocationResponse: Decodable {
    let data: CurrentLocationData
    let message: String
    let code: String
}

struct CurrentLocationData: Decodable {
    let results: [LocationResult]
}

struct LocationResult: Decodable {
    let region: Region
}

struct Region: Decodable {
    let area1: Area
    let area2: Area
    let area3: Area
    let area4: Area
}

struct Area: Codable {
    let name: String
}

extension CurrentLocationResponse {
    var toDomain: CurrentLocationModel {
        
        guard data.results.isEmpty != true else {
            return CurrentLocationModel(address: "주소 변환 에러")
        }
        let area1 = data.results[0].region.area1.name
        let area2 = data.results[0].region.area2.name
        let area3 = data.results[0].region.area3.name
        let area4 = data.results[0].region.area4.name
        
        if area4.isEmpty {
            return CurrentLocationModel(address: area2 + " " + area3)
        } else {
            return CurrentLocationModel(address: area3 + " " + area4)
        }
    }
}

