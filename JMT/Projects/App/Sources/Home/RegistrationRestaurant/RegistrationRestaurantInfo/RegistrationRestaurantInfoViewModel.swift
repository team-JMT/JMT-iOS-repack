//
//  RegistrationRestaurantInfoViewModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit

class RegistrationRestaurantInfoViewModel {
    
    // MARK: - Properties
    // 데이터와 관련된 프로퍼티들을 선언하는 부분입니다.
    weak var coordinator: RegistrationRestaurantInfoCoordinator?
    var info: SearchRestaurantsLocationModel?
    
    var categoryData: [(String, Bool, UIImage)] = []
    var isSelectedCategory = false
    var selectedImages = [UIImage]()
    var commentString: String = ""
    var isDrinking = false
    var drinkingComment: String = ""
    var tags = [String]()
    
    var selectedGroupId: Int?
    var restaurantLocationId: Int?
    var recommendRestaurantId: Int?
    
    var didUpdateCategory: (() -> Void)?
    var didCompletedSelectedImages: (() -> Void)?
    var didCompletedCommentString: (() -> Void)?
    var didCompletedIsDrinking: (() -> Void)?
    var didCompletedDrinkingComment: (() -> Void)?
    var didCompletedTags: ((Bool) -> Void)?
    var didCompletedDeleteTag: (() -> Void)?
    var didCompletedCheckInfo: ((checkInfoType) -> Void)?
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.
    
    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.
    
    // MARK: - Data Fetching
    // 외부 소스나 모델로부터 데이터를 가져오는 메소드들을 모아두는 부분입니다.
    func registrationRestaurantLocation() async throws {
        
        do {
            if let info = self.info {
                let request = RegistrationRestaurantLocationRequest(
                    placeName: info.placeName,
                    distance: String(0),
                    placeUrl: info.placeUrl,
                    categoryName: info.categoryName,
                    addressName: info.addressName,
                    roadAddressName: info.roadAddressName,
                    id: info.id,
                    phone: info.phone,
                    categoryGroupCode: info.categoryGroupCode,
                    categoryGroupName: info.categoryGroupName,
                    x: String(info.x),
                    y: String(info.y))
                
                let response = try await RegistrationRestaurantAPI.registrationRestaurantLocationAsync(request: request)
                print(response)
                restaurantLocationId = response.data
            }
        } catch {
            print(error)
            throw RestaurantError.registrationRestaurantLocationError
        }
    }
    
    func registrationRestaurantAsync() async throws {
        
        do {
            if let info = self.info, let selectedGroupId = self.selectedGroupId {
                
                let categoryId = categoryData.firstIndex(where: {$0.1 == true }).map({Int($0)}) ?? 0
                
                let recommendMenu = tags.joined()
                            
                let request = RegistrationRestaurantRequest(
                    name: info.placeName,
                    introduce: commentString,
                    categoryId: categoryId + 1,
                    canDrinkLiquor: isDrinking,
                    goWellWithLiquor: drinkingComment,
                    recommendMenu: recommendMenu,
                    restaurantLocationId: self.restaurantLocationId ?? 0,
                    groupId: selectedGroupId)
 
                let response = try await RegistrationRestaurantAPI.registrationRestaurantAsync(request: request, images: selectedImages)
                recommendRestaurantId = response.data.recommendRestaurantId
            } else {
                print("registrationRestaurantAsync Error")
            }
        } catch {
            print(error)
            throw RestaurantError.registrationRestaurantAsyncError
        }
    }
    
    // MARK: - Utility Methods
    // 다양한 유틸리티 메소드들을 모아두는 부분입니다. 예를 들어, 날짜 포매팅이나 데이터 검증 등입니다.
    func updateSelectedCategory(row: Int) {
        for (index, _) in categoryData.enumerated() {
            if index == row {
                categoryData[index].1 = true
            } else {
                categoryData[index].1 = false
            }
        }
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

// 미입력 정보 체크
extension RegistrationRestaurantInfoViewModel {
    
    enum checkInfoType {
        case category
        case commentString
        case drinkingComment
        case tags
    }
    
    func checkNotInfo() -> Bool {

        if isSelectedCategory == false {
            didCompletedCheckInfo?(.category)
            return false
        }
        
        if commentString == "" {
            didCompletedCheckInfo?(.commentString)
            return false
        }
        
        if isDrinking == true {
            if drinkingComment == "" {
                didCompletedCheckInfo?(.drinkingComment)
                return false
            }
        }
        
        if tags.isEmpty == true {
            didCompletedCheckInfo?(.tags)
            return false
        }
        
        return true
    }
}
