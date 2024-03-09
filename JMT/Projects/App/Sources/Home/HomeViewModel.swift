//
//  HomeViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation
import UIKit
import CoreLocation
import NMapsMap

class HomeViewModel {
    enum SelectedSortType {
        case sort
        case category
        case drinking
    }
    
    enum SortRestaurantType {
        case location
        case recent
    }
    
    enum SortCategoryType: Int {
        case korean = 0
        case japanese
        case chinese
        case western
        case fusion
        case cafe
        case bar
        case etc
        case initType
        case none = 99999

        var countryCode: String {
            switch self {
            case .korean:
                return "KOREA"
            case .japanese:
                return "JAPAN"
            case .chinese:
                return "CHINA"
            case .western:
                return "FOREIGN"
            case .fusion:
                return "FUSION"
            case .cafe:
                return "CAFE"
            case .bar:
                return "BAR"
            case .etc:
                return "ETC"
            case .initType:
                return ""
            case .none:
                return ""
            }
        }
    }
    
    weak var coordinator: HomeCoordinator?
    
    var locationManager = LocationManager()
    var location: CLLocationCoordinate2D?
    
//    // 위치 관련
//    var didUpdateCurrentAddress: ((String) -> Void)?
    var displayAlertHandler: (() -> Void)?
//    
//    // 소속 그룹 관련
//    var didCompletedCheckJoinGroup: (() -> Void)?
    var didUpdateGroupName: ((Int) -> Void)?
//    
//    // 맛집 리스트 관련
    var didUpdateSkeletonView: (() -> Void)?
    var didUpdateBottomSheetTableView: (() -> Void)?
//    var didUpdateSortTypeButton: (() -> Void)?

    // 필터 관련
    var didUpdateFilterRestaurants: (() -> Void)?
    var didUpdateFilterTableView: (() -> Void)?

//    // 지도 관련
//    var didUpdateMapMarker: (() -> Void)?
    
    let sortList = ["가까운 순", "최신 순"]
    let categoryList = ["한식", "일식", "중식", "양식", "퓨전", "카페", "주점", "기타"]
    let drinkingList = ["주류 가능", "주류 불가능/모름"]
    
    var sortType: SelectedSortType = .sort
    
    var originalCategoryIndex: Int? = nil
    var originalDrinkingIndex: Int? = nil
    
    var selectedSortIndex: Int = 0
    var selectedCategoryIndex: Int? = nil
    var selectedDrinkingIndex: Int? = nil
    
    var page: Int = 0
    var currentGroupId: Int = 1

    var isLodingData: Bool = true
    
    var groupList: [MyGroupData] = []

    var popularRestaurants: [SearchMapRestaurantItems] = []
    var restaurants: [SearchMapRestaurantItems] = []
    var markerRestaurants: [SearchMapRestaurantItems] = []
    
    var reviews: [FindRestaurantReview] = []
}

// 데이터 관련 메소드
extension HomeViewModel {
    
    // 바텀치트 1번째 섹션에 보여줄 데이터
    func fetchRecentRestaurantsAsync() async throws {
        
        popularRestaurants.removeAll()
        
        let parameters = SearchMapRestaurantPageRequest(page: 1, size: 5, sort: "id,desc")
        let body = SearchMapRestaurantRequestBody(
            userLocation: nil,
            startLocation: nil,
            endLocation: nil,
            filter: nil,
            groupId: currentGroupId) // 그룹 아이디 변경해야함
        
        do {
            let data = try await FetchRestaurantAPI.fetchSearchMapRestaurantsAsync(request: SearchMapRestaurantRequest(parameters: parameters, body: body))
            self.popularRestaurants.append(contentsOf: data)
        } catch {
            throw RestaurantError.fetchRecentRestaurantsAsyncError
        }
    }
    
    // 바텀시트 2번째 섹션에 보여줄 데이터
    func fetchGroupRestaurantsAsync() async throws {
    
        restaurants.removeAll()
        
        var parameters: SearchMapRestaurantPageRequest!
        var body: SearchMapRestaurantRequestBody!
       
        let categoryFilter = selectedCategoryIndex == nil ? nil : selectedCategoryIndex
        let isCanDrinkLiquor = selectedDrinkingIndex == nil ? nil : (selectedDrinkingIndex == 0 ? true : false)
        
        if selectedSortIndex == 0 {
            parameters =  SearchMapRestaurantPageRequest(page: 1, size: 20, sort: nil)
            body = SearchMapRestaurantRequestBody(
                userLocation: SearchMapRestaurantLocation(x: "\(locationManager.location?.coordinate.longitude ?? 0.0)", y: "\(locationManager.location?.coordinate.latitude ?? 0.0)"),
                startLocation: nil,
                endLocation: nil,
                filter: SearchMapRestaurantFilter(categoryFilter: SortCategoryType(rawValue: categoryFilter ?? 0)?.countryCode, isCanDrinkLiquor: isCanDrinkLiquor),
                groupId: currentGroupId)
        } else {
            parameters = SearchMapRestaurantPageRequest(page: 1, size: 20, sort: "id,desc")
            body = SearchMapRestaurantRequestBody(
                userLocation: nil,
                startLocation: nil,
                endLocation: nil,
                filter: SearchMapRestaurantFilter(categoryFilter: SortCategoryType(rawValue: categoryFilter ?? 0)?.countryCode, isCanDrinkLiquor: isCanDrinkLiquor),
                groupId: currentGroupId)
        }
        
        do {
            let data = try await FetchRestaurantAPI.fetchSearchMapRestaurantsAsync(request: SearchMapRestaurantRequest(parameters: parameters, body: body))
            self.restaurants.append(contentsOf: data)
        } catch {
            throw RestaurantError.fetchGroupRestaurantsAsyncError
        }
    }
    
    // 새로고침 버튼으로 마커 찍기
    func fetchMapIncludedRestaurantsAsync(withinBounds bounds: NMGLatLngBounds) async throws {
        
        markerRestaurants.removeAll()
        
        let parameters = SearchMapRestaurantPageRequest(page: 1, size: 20, sort: nil)
        let body = SearchMapRestaurantRequestBody(
            userLocation: SearchMapRestaurantLocation(x: "\(locationManager.location?.coordinate.longitude ?? 0.0)", y: "\(locationManager.location?.coordinate.latitude ?? 0.0)"),
            startLocation: SearchMapRestaurantLocation(x: "\(bounds.southWestLng)", y: "\(bounds.southWestLat)"),
            endLocation: SearchMapRestaurantLocation(x: "\(bounds.northEastLng)", y: "\(bounds.northEastLat)"),
            filter: nil,
            groupId: currentGroupId)
        
        do {
            let data = try await FetchRestaurantAPI.fetchSearchMapRestaurantsAsync(request: SearchMapRestaurantRequest(parameters: parameters, body: body))
            self.markerRestaurants.append(contentsOf: data)
        } catch {
            throw RestaurantError.fetchMapIncludedRestaurantsAsyncError
        }
    }
}

// 지도 관련 메소드
extension HomeViewModel {
    
    func markerImage(category: String) -> String? {
        switch category {
        case "한식":
            return JMTengAsset.marker1.name
        case "일식":
            return JMTengAsset.marker2.name
        case "중식":
            return JMTengAsset.marker3.name
        case "양식":
            return JMTengAsset.marker4.name
        case "퓨전":
            return JMTengAsset.marker5.name
        case "카페":
            return JMTengAsset.marker6.name
        case "주류":
            return JMTengAsset.marker7.name
        case "기타":
            return JMTengAsset.marker8.name
        default:
            // 임시
            return JMTengAsset.marker2.name
        }
    }
}

// 필터링 관련 메소드
extension HomeViewModel {
    
    // 타입 변경시
    func updateSortType(type: SelectedSortType) {
        sortType = type
//        didUpdateSortTypeButton?()
    }
    
    // 필터 옵션 변경시
    func updateIndex(row: Int) {
        switch sortType {
        case .sort:
            selectedSortIndex = row
            didUpdateFilterRestaurants?()
        case .category:
            selectedCategoryIndex = row
        case .drinking:
            selectedDrinkingIndex = row
        }
    }
    
    // 선택한 옵션 저장
    func saveUpdateIndex() {
        originalCategoryIndex = selectedCategoryIndex
        originalDrinkingIndex = selectedDrinkingIndex
    }
    
    // 옵션 변경 취소
    func cancelUpdateIndex() {
        if originalCategoryIndex != selectedCategoryIndex {
            selectedCategoryIndex = originalCategoryIndex
        }
        
        if originalDrinkingIndex != selectedDrinkingIndex {
            selectedDrinkingIndex = originalDrinkingIndex
        }
    }
    
    // 필터 옵션 초기화
    func resetUpdateIndex() {
        switch sortType {
        case .category:
            selectedCategoryIndex = nil
        case .drinking:
            selectedDrinkingIndex = nil
        default:
            return
        }
    }
}

// 그룹 관련 메소드
extension HomeViewModel {
    
    func fetchJoinGroup() async throws -> Bool {
        
        let groupList = try await GroupAPI.fetchMyGroupAsync()
        
        if groupList.isEmpty {
            return false
        } else {
            self.groupList.append(contentsOf: groupList)
            self.groupList.append(MyGroupData(groupId: 1, groupName: "123123", groupIntroduce: "123123", groupProfileImageUrl: "123123", groupBackgroundImageUrl: "!23123", privateGroup: false, isSelected: false))
            let id = groupList.firstIndex(where: { $0.isSelected == true }).map({Int($0)})
            currentGroupId = id ?? 0
            UserDefaultManager.selectedGroupId = id ?? 0
            return true
        }
    }
    
    func updateSelectedGroup(id: Int) async throws {
        try await GroupAPI.updateSelectedGroupAsync(request: SelectedGroupRequest(groupId: id))
        
        for (index, group) in groupList.enumerated() {
            if group.groupId == id {
                groupList[index].isSelected = true
            } else {
                groupList[index].isSelected = false
            }
        }
        currentGroupId = id
        UserDefaultManager.selectedGroupId = id 
    }
}

// 위치 관련 메소드
extension HomeViewModel {
    
    func fetchCurrentAddressAsync() async throws -> String? {
        
        guard self.location != nil else { return nil }
        
        let lat: String = String(self.location?.latitude ?? 0.0)
        let lon: String = String(self.location?.longitude ?? 0.0)
        
        let locationData = try await CurrentLocationAPI.fetchCurrentLoctionAsync(request: CurrentLocationRequest(coords: "\(lon),\(lat)"))
        return locationData.address
       
    }
}
