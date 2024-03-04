//
//  HomeViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation
import UIKit
import CoreLocation

class HomeViewModel {
    
    enum SelectedSortType {
        case sort
        case category
        case drinking
    }
    
    weak var coordinator: HomeCoordinator?
    
    var locationManager = LocationManager()
    var location: CLLocationCoordinate2D?
    
    var didUpdateCurrentAddress: ((String) -> Void)?
    
//    init() {
//        authorizationStatusChanged()
//        updateCurrentLocation()
//    }
    
    var didUpdateFilters: ((Bool) -> Void)?
    var didUpdateSortTypeButton: (() -> Void)?
    
    var didUpdateSkeletonView: (() -> Void)?
    var didUpdateGroupName: ((Int) -> Void)?
    var didUpdateBottomSheetTableView: (() -> Void)?
    
    var displayAlertHandler: (() -> Void)?
    var onUpdateCurrentLocation: ((Double, Double) -> Void)?
    
    var didCompletedCheckJoinGroup: (() -> Void)?
    
    var didTest: (() -> Void)?
    
    var didUpdateIndex: ((Int) -> Void)?
    
    let sortList = ["가까운 순", "좋아요 순", "최신 순"]
    let categoryList = ["한식", "일식", "중식", "양식", "퓨전", "카페", "주점", "기타"]
    let drinkingList = ["주류 가능", "주류 불가능/모름"]
    
    var sortType: SelectedSortType = .sort
    
    var originalCategoryIndex: Int = 99999
    var originalDrinkingIndex: Int = 99999
    
    var selectedSortIndex: Int = 0
    var selectedCategoryIndex: Int = 99999
    var selectedDrinkingIndex: Int = 99999
    
    var isNotGroup: Bool = false
    var isLodingData: Bool = true
    
    var groupList: [GroupData] = []

    var popularRestaurants: [GroupRestaurantsInfoModel] = generateDummyData(count: 100)
    var restaurants: [GroupRestaurantsInfoModel] = generateDummyData2(count: 100)
    
    var filterPopularRestaurants: [GroupRestaurantsInfoModel] = []
    var filterRestaurants: [GroupRestaurantsInfoModel] = []
}

// 데이터 관련 메소드
extension HomeViewModel {
    func fetchRestaurantsData() {
        
        didUpdateSkeletonView?()
        isLodingData = true
        
        filterPopularRestaurants.removeAll()
        filterRestaurants.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            let filteredRestaurants = self.popularRestaurants.filter { restaurant in
                let matchesCategory = self.selectedCategoryIndex == 99999 || self.categoryList[self.selectedCategoryIndex] == restaurant.category
                let matchesDrinking = self.selectedDrinkingIndex == 99999 || self.drinkingList[self.selectedDrinkingIndex] == restaurant.canDrinkLiquor
                return matchesCategory && matchesDrinking
            }
            
            let filteredRestaurants2 = self.restaurants.filter { restaurant in
                let matchesCategory = self.selectedCategoryIndex == 99999 || self.categoryList[self.selectedCategoryIndex] == restaurant.category
                let matchesDrinking = self.selectedDrinkingIndex == 99999 || self.drinkingList[self.selectedDrinkingIndex] == restaurant.canDrinkLiquor
                return matchesCategory && matchesDrinking
            }
            
            // 정렬
            let sortedRestaurants = filteredRestaurants.sorted { (first:GroupRestaurantsInfoModel , second: GroupRestaurantsInfoModel) in
                switch self.sortList[self.selectedSortIndex] {
                case "가까운 순":
                    return first.differenceInDistance < second.differenceInDistance // 예시, 실제 모델에 맞게 조정
                case "좋아요 순":
                    return first.likeCount > second.likeCount // 예시, 실제 모델에 맞게 조정
                case "최신 순":
                    return first.id > second.id // 예시, 실제 모델에 맞게 조정
                default:
                    return true
                }
            }
            
            let sortedRestaurants2 = filteredRestaurants2.sorted { (first:GroupRestaurantsInfoModel , second: GroupRestaurantsInfoModel) in
                switch self.sortList[self.selectedSortIndex] {
                case "가까운 순":
                    return first.differenceInDistance < second.differenceInDistance // 예시, 실제 모델에 맞게 조정
                case "좋아요 순":
                    return first.likeCount > second.likeCount // 예시, 실제 모델에 맞게 조정
                case "최신 순":
                    return first.id > second.id // 예시, 실제 모델에 맞게 조정
                default:
                    return true
                }
            }
            
            // 결과 할당
            self.filterPopularRestaurants = sortedRestaurants
            self.filterRestaurants = sortedRestaurants2
            
            self.isLodingData = false
            self.didUpdateBottomSheetTableView?()
        }
    }
}

// 지도 관련 메소드
extension HomeViewModel {
    
    // 설정 좌표로 Address 조회
    func getCurrentLocationAddress(lat: String, lon: String, completed: @escaping (String) -> ()) {
        
        CurrentLocationAPI.getCurrentLocation(request: CurrentLocationRequest(coords: "\(lon),\(lat)")) { response in
            switch response {
            case .success(let locationData):
                completed(locationData.address)
            case .failure(let error):
                completed("검색 중")
            }
        }
    }
    
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
        didUpdateSortTypeButton?()
    }
    
    // 필터 옵션 변경시
    func updateIndex(row: Int) {
        switch sortType {
        case .sort:
            selectedSortIndex = row
            didUpdateFilters?(true)
            fetchRestaurantsData()
        case .category:
            selectedCategoryIndex = row
            didUpdateFilters?(false)
        case .drinking:
            selectedDrinkingIndex = row
            didUpdateFilters?(false)
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
            selectedCategoryIndex = 99999
        case .drinking:
            selectedDrinkingIndex = 99999
        default:
            return
        }
        
        didUpdateFilters?(false)
    }
}


// 위치 관련 메소드
extension HomeViewModel {
    
//    // 위치 정보 권한 체크
//    func checkLocationAuthorization() {
//        locationManager.checkUserDeviceLocationServiceAuthorization()
//    }
//
//    // 위치 권한 거부시 Alert
//    func authorizationStatusChanged() {
//        locationManager.onAuthorizationStatusChanged = { isAuthorized in
//            if !isAuthorized {
//                print("실패")
//                self.displayAlertHandler?()
//            }
//        }
//    }
//
//    // 위치 정보를 맵에 표시
//    func updateCurrentLocation() {
//        locationManager.didUpdateCurrentLocation = {
//
//            let lat = self.locationManager.currentLocation?.latitude ?? 0.0
//            let lon = self.locationManager.currentLocation?.longitude ?? 0.0
//
//            self.onUpdateCurrentLocation?(lat, lon)
//        }
//    }
//
//    func refreshCurrentLocation() {
//        locationManager.refreshCurrentLocation()
//    }
}

// 그룹 가입 여부 분기 처리
extension HomeViewModel {
    
    func checkJoinGorup() {
        GroupAPI.fetchMyGroup { response in
            switch response {
            case .success(let groupList):
                self.groupList = groupList.data
                self.didCompletedCheckJoinGroup?()
            case .failure(let failure):
                self.groupList.removeAll()
                self.didCompletedCheckJoinGroup?()
            }
        }
    }
}



extension HomeViewModel {

    func fetchCurrentLocation() {
        locationManager.fetchLocation { [weak self] (location, error) in
            self?.location = location
            
            self?.fetchCurrentAddress(completion: { address in
                self?.didUpdateCurrentAddress?(address)
            })
        }
    }
    
    func fetchCurrentAddress(completion: @escaping (String) -> ()) {
        
        guard self.location != nil else { return }
        
        let lat: String = String(self.location?.latitude ?? 0.0)
        let lon: String = String(self.location?.longitude ?? 0.0)
        
        CurrentLocationAPI.getCurrentLocation(request: CurrentLocationRequest(coords: "\(lon),\(lat)")) { response in
            switch response {
            case .success(let locationData):
                completion(locationData.address)
            case .failure(let error):
                completion("검색 중")
            }
        }
    }
}
