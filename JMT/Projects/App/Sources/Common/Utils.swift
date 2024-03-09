//
//  Utils.swift
//  JMTeng
//
//  Created by PKW on 2024/01/17.
//

import Foundation
import UIKit

struct Utils {
    static func getDefaultCategoryData() -> [(name: String, isSelected: Bool, image: UIImage)] {
        return [
            ("한식", false, JMTengAsset.category1.image),
            ("일식", false, JMTengAsset.category2.image),
            ("중식", false, JMTengAsset.category3.image),
            ("양식", false, JMTengAsset.category4.image),
            ("퓨전", false, JMTengAsset.category5.image),
            ("카페", false, JMTengAsset.category6.image),
            ("주점", false, JMTengAsset.category7.image),
            ("기타", false, JMTengAsset.category8.image)
        ]
    }
}
