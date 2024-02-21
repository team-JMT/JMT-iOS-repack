//
//  UIString+Ext.swift
//  JMTeng
//
//  Created by PKW on 2024/02/20.
//

import Foundation

extension String {
    func distanceWithUnit() -> String {
        guard let distance = Double(self) else { return "Invalid distance" }
        
        if distance < 1000 {
            // 1킬로미터 이하이면 미터 단위로 표시
            return "\(Int(distance)) m"
        } else {
            // 1킬로미터 이상이면 킬로미터 단위로 변환하여 표시
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
}
