//
//  RegistrationRestaurantInfoViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit

class RegistrationRestaurantInfoViewModel {
    weak var coordinator: RegistrationRestaurantInfoCoordinator?
    
    var didCompletedFilterType: (() -> Void)?
    var didCompletedSelectedImages: (() -> Void)?
    var didCompletedCommentString: (() -> Void)?
    var didCompletedIsDrinking: (() -> Void)?
    var didCompletedDrinkingComment: (() -> Void)?
    var didCompletedTags: ((Bool) -> Void)?
    var didCompletedDeleteTag: (() -> Void)?
    
    let typeNames = ["한식", "일식", "중식", "양식", "퓨전", "카페", "주점", "기타"]
    
    var isSelectedFilterType: Bool = false
    
    var filterType: Int = 0
    var selectedImages = [UIImage]()
    var commentString: String = ""
    var isDrinking = false
    var drinkingComment: String = ""
    var tags = [String]()
    
    func updateIsSelectedFilterType() {
        isSelectedFilterType = true
    }
    
    func updateFilterType(type: Int) {
        self.filterType = type
    }
    
    func updateSelectedImages(images: [UIImage]) {
        self.selectedImages.append(contentsOf: images)
    }
    
    func updateCommentString(text: String) {
        self.commentString = text
    }
    
    func updateIsDrinking(isDrinking: Bool) {
        self.isDrinking = isDrinking
    }
    
    func updateDrinkingComment(text: String) {
        self.drinkingComment = text
    }
    
    func updateTags(tag: String) {
        
        // 공백인지 체크
        if !tag.trimmingCharacters(in: .whitespaces).isEmpty {
            
            // #이 포함되었는지 체크
            if tag.contains("#") {
            
                let normalizedText = normalizeHashTags(in: tag)
                let splitStr = splitString(in: normalizedText)
                
                for str in splitStr {
                    // tags 배열의 크기가 6이면 더이상 추가하지 않고 종료
                    if tags.count >= 6 {
                        print("태그는 최대 6개까지만 추가할 수 있습니다.")
                        didCompletedTags?(true)
                        return
                    }
                    
                    // tags 배열에 요소 추가
                    if !tags.contains(str) {
                        tags.append(str)
                    }
                }
                
                // 태그 추가 완료 후 콜백 호출
                didCompletedTags?(true)
                
            } else {
                print("# 미포함")
                didCompletedTags?(false)
            }
        } else {
            print("공백이면")
            didCompletedTags?(false)
        }
    }
    
    func deleteTags(index: Int) {
        tags.remove(at: index)
        didCompletedDeleteTag?()
    }
}

// 태그 로직 관련 메소드
extension RegistrationRestaurantInfoViewModel {
    func normalizeHashTags(in text: String) -> String {
        var normalizedText = text
        // 연속된 '#' 패턴을 찾기 위한 정규 표현식
        let regex = try! NSRegularExpression(pattern: "#+", options: [])
        
        // 모든 연속된 '#'을 하나의 '#'으로 변경
        let range = NSRange(location: 0, length: normalizedText.utf16.count)
        normalizedText = regex.stringByReplacingMatches(in: normalizedText, options: [], range: range, withTemplate: "#")
        
        return normalizedText
    }
    
    func splitString(in text: String) -> [String] {
    
        let strings = text.split(separator: "#").map({ String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
        print(strings)
        
        let filteredStrings = strings.filter { $0.range(of: "^[가-힣]+$", options: .regularExpression) != nil }
        
        let uniqueNumbers = removeDuplicates(array: filteredStrings)
        
        return uniqueNumbers.map { "#\($0)" }.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    // 중복 체크
    func removeDuplicates(array: [String]) -> [String] {
        var result = [String]()
        
        for str in array {
            if !result.contains(str) {
                result.append(str)
            }
        }
        
        return result
    }
}
