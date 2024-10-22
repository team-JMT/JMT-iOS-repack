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
    // MARK: - Properties
    // 필터 타입
    enum SelectedSortType {
        case sort
        case category
        case drinking
    }
    
    // 위치 기반 정렬 기준 타입
    enum SortRestaurantType {
        case location
        case recent
    }
    
    // 카테고리 정렬 타입
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
    
    // MARK: - Properties
    // 데이터와 관련된 프로퍼티들을 선언하는 부분입니다.
    let locationManager = LocationManager.shared
    weak var coordinator: HomeCoordinator?
//    var coordinate: CLLocationCoordinate2D?
    
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
    var currentGroupId: Int? = 0

    var isLodingData: Bool = true
    
    var groupList: [MyGroupData] = []

    var popularRestaurants: [RestaurantListModel] = []
    var restaurants: [RestaurantListModel] = []
    var markerRestaurants: [RestaurantListModel] = []
    
    var reviews: [FindRestaurantReviewsData] = []
    var isFirstLodingData = true
    
    // MARK: - Initialization
    // 뷰모델 초기화와 관련된 로직을 담당하는 부분입니다.
    
    // MARK: - Data Binding
    // 뷰와 뷰모델 간의 데이터 바인딩을 설정하는 부분입니다.

    // MARK: - Utility Methods
    // 다양한 유틸리티 메소드들을 모아두는 부분입니다. 예를 들어, 날짜 포매팅이나 데이터 검증 등입니다.
    
    // MARK: - Error Handling
    // 에러 처리와 관련된 로직을 담당하는 부분입니다.
    var didUpdateGroupRestaurantsData: (() -> Void)?
    
    var displayAlertHandler: (() -> Void)?

    // 소속 그룹 관련
    var didUpdateGroupName: ((Int) -> Void)?
    
    // 맛집 리스트 관련
    var didUpdateSkeletonView: (() -> Void)?
    var didUpdateBottomSheetTableView: (() -> Void)?

    // 필터 관련
    var didUpdateFilterTableView: (() -> Void)?
}

// MARK: - Data Fetching
extension HomeViewModel {
    //  MARK: - 그룹 맛집 정보 관련 메소드
    // 바텀시트 1번째 섹션에 보여줄 데이터
    func fetchRecentRestaurantsAsync() async throws {
        
        popularRestaurants.removeAll()
        
        let parameters = PageRequest(page: 1, size: 10, sort: "id,desc")
        let body = RestaurantListRequestBody(userLocation: nil,
                                             startLocation: nil,
                                             endLocation: nil,
                                             filter: nil,
                                             groupId: currentGroupId ?? -1)
    
        do {
            let data = try await ReadRestaurantsAPI.fetchRestaurantListAsync(request: RestaurantListRequest(parameters: parameters,
                                                                                                              body: body))
            self.popularRestaurants.append(contentsOf: data.toDomain)
        } catch {
            print(error)
            throw RestaurantError.fetchRecentRestaurantsAsyncError
        }
    }
    
    // 바텀시트 2번째 섹션에 보여줄 데이터
    func fetchGroupRestaurantsAsync() async throws {
    
        restaurants.removeAll()
       
        var parameters: PageRequest
        var body: RestaurantListRequestBody
        
        let categoryFilter = selectedCategoryIndex == nil ? nil : selectedCategoryIndex
        let isCanDrinkLiquor = selectedDrinkingIndex == nil ? nil : (selectedDrinkingIndex == 0 ? true : false)
        
        if selectedSortIndex == 0 {
            parameters = PageRequest(page: 1, size: 20, sort: nil)
            body = RestaurantListRequestBody(userLocation: LocationRequest(x: "\(LocationManager.shared.coordinate?.longitude ?? 0.0)",
                                                                           y: "\(LocationManager.shared.coordinate?.latitude ?? 0.0)"),
                                             startLocation: nil,
                                             endLocation: nil,
                                             filter: FilterRequest(categoryFilter: categoryFilter == nil ? nil : SortCategoryType(rawValue: categoryFilter ?? 0)?.countryCode,
                                                                   isCanDrinkLiquor: isCanDrinkLiquor),
                                             groupId: currentGroupId ?? -1)
        } else {
            parameters = PageRequest(page: 1, size: 20, sort: "id,desc")
            body = RestaurantListRequestBody(userLocation: nil,
                                             startLocation: nil,
                                             endLocation: nil,
                                             filter: FilterRequest(categoryFilter: categoryFilter == nil ? nil : SortCategoryType(rawValue: categoryFilter ?? 0)?.countryCode,
                                                                   isCanDrinkLiquor: isCanDrinkLiquor),
                                             groupId: currentGroupId ?? -1)
        }
        
        do {
            let data = try await ReadRestaurantsAPI.fetchRestaurantListAsync(request: RestaurantListRequest(parameters: parameters, body: body))
            self.restaurants.append(contentsOf: data.toDomain)
        } catch {
            print(error)
            throw RestaurantError.fetchGroupRestaurantsAsyncError
        }
    }
    
    // 새로고침 버튼으로 마커 찍기
    func fetchMapIncludedRestaurantsAsync(withinBounds bounds: NMGLatLngBounds) async throws {
        
        markerRestaurants.removeAll()
        
        let parameters = PageRequest(page: 1, size: 20, sort: nil)
        let body = RestaurantListRequestBody(userLocation: LocationRequest(x: "\(LocationManager.shared.coordinate?.longitude ?? 0.0)",
                                                                           y: "\(LocationManager.shared.coordinate?.latitude ?? 0.0)"),
                                             startLocation: LocationRequest(x: "\(bounds.southWestLng)",
                                                                            y: "\(bounds.southWestLat)"),
                                             endLocation: LocationRequest(x: "\(bounds.northEastLng)",
                                                                          y: "\(bounds.northEastLat)"),
                                             filter: FilterRequest(categoryFilter: nil, isCanDrinkLiquor: nil),
                                             groupId: currentGroupId ?? -1)
    
        do {
            let data = try await ReadRestaurantsAPI.fetchRestaurantListAsync(request: RestaurantListRequest(parameters: parameters, body: body))
            self.markerRestaurants.append(contentsOf: data.toDomain)
        } catch {
            print(error)
            throw RestaurantError.fetchMapIncludedRestaurantsAsyncError
        }
    }
    
    func fetchRestaurantsReviewsAsync() async throws {
        var updatedRestaurants = [RestaurantListModel]()
        
        for restaurant in restaurants {
            let reviewData = try await ReadRestaurantsAPI.fetchRestaurantReviewsAsync(request: RestaurantReviewsRequest(recommendRestaurantId: restaurant.id)).toDomain
            
            // 리뷰 데이터를 할당하여 새로운 Restaurant 인스턴스 생성
            var updatedRestaurant = restaurant
            updatedRestaurant.reviews = reviewData
            
            // 업데이트된 레스토랑을 배열에 추가
            updatedRestaurants.append(updatedRestaurant)
        }
        
        // 완료된 후, 전체 배열을 업데이트
        self.restaurants = updatedRestaurants
    }
    
    // MARK: - 위치 관련 메소드
    func fetchCurrentAddressAsync() async throws -> String? {
        let lon = String(locationManager.coordinate?.longitude ?? 0.0)
        let lat = String(locationManager.coordinate?.latitude ?? 0.0)
        
        do {
            let locationData = try await LocationAPI.fetchCurrentLoctionAsync(request: CurrentLocationRequest(coords: "\(lon),\(lat)")).toDomain
            return locationData.address
        } catch {
            throw RestaurantError.fetchCurrentAddressAsyncError
        }
    }
    
    // MARK: - 지도 관련 메소드
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
    
    // MARK: - 필터링 관련 메소드
    // 타입 변경시
    func updateSortType(type: SelectedSortType) {
        sortType = type
    }
    
    // 필터 옵션 변경시
    func updateIndex(row: Int) {
        switch sortType {
        case .sort:
            selectedSortIndex = row
            didUpdateGroupRestaurantsData?()
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
    
    // MARK: - 그룹 관련 메소드
    func fetchJoinGroup() async throws {
        do {
            groupList = try await ReadGroupAPI.fetchMyGroupAsync().data
            
            if groupList.isEmpty == false {
                let index = groupList.firstIndex(where: { $0.isSelected == true }) ?? 0
                currentGroupId = groupList[index].groupId
                UserDefaultManager.selectedGroupId = currentGroupId
            } else {
                currentGroupId = nil
                UserDefaultManager.selectedGroupId = nil
            }
        } catch {
            throw RestaurantError.fetchJoinGroupError
        }
    }
    
    func updateSelectedGroup(id: Int) async throws {
        do {
            try await UpdateGroupAPI.updateSelectedGroupAsync(request: SelectedGroupRequest(groupId: id))
            
            for (index, group) in groupList.enumerated() {
                if group.groupId == id {
                    groupList[index].isSelected = true
                } else {
                    groupList[index].isSelected = false
                }
            }
            currentGroupId = id
            UserDefaultManager.selectedGroupId = id
        } catch {
            throw RestaurantError.updateSelectedGroupError
        }
    }
}
