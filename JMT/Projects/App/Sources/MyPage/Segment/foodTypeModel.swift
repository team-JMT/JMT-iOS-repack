//
//  foodTypeModel.swift
//  JMTeng
//
//  Created by 이지훈 on 3/18/24.
//

import Foundation
import UIKit

struct FoodType {
    let filter: FilterType
    let name: String
    let image: UIImage?
    let identifier: String //식별자

    enum FilterType: String { // api용
        case KOREA = "한식"
        case JAPAN = "일식"
        case CHINA = "중식"
        case FOREIGN = "양식"
        case FUSION = "퓨전"
        case CAFE = "카페"
        case BAR = "주점"
        case ETC = "기타"
        
        var identifier: String {  // 필터링용 식별자 계산속성
            switch self {
            case .KOREA: return "KOREA"
            case .JAPAN: return "JAPAN"
            case .CHINA: return "CHINA"
            case .FOREIGN: return "FOREIGN"
            case .FUSION: return "FUSION"
            case .CAFE: return "CAFE"
            case .BAR: return "BAR"
            case .ETC: return "ETC"
            }
        }
    }

    init(filter: FilterType, image: UIImage? = nil) {
        self.filter = filter
        self.name = filter.rawValue
        self.image = image
        self.identifier = filter.identifier  // 식별자 초기화
    }
}
