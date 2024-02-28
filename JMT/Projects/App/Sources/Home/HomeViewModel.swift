//
//  HomeViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

class HomeViewModel {
    
    enum SelectedSortType {
        case sort
        case category
        case drinking
    }
    
    weak var coordinator: HomeCoordinator?
    
    var locationManager = LocationManager.shared
    
    init() {
        authorizationStatusChanged()
        updateCurrentLocation()
    }
    
    var didUpdateFilters: ((Bool) -> Void)?
    var didUpdateSortTypeButton: (() -> Void)?
    var didUpdateBottomSheetTableView: (() -> Void)?
    
    var displayAlertHandler: (() -> Void)?
    var onUpdateCurrentLocation: ((Double, Double) -> Void)?
    
    var didCompletedCheckJoinGroup: ((Bool) -> Void)?
    
    var didTest: (() -> Void)?
    
    let sortList = ["가까운 순", "좋아요 순", "최신 순"]
    let categoryList = ["한식", "일식", "중식", "양식", "퓨전", "카페", "주점", "기타"]
    let drinkingList = ["주류 가능", "주류 불가능/모름"]
    
    var sortType: SelectedSortType = .sort
    
    var originalCategoryIndex: Int = 99999
    var originalDrinkingIndex: Int = 99999
    
    var selectedSortIndex: Int = 0
    var selectedCategoryIndex: Int = 99999
    var selectedDrinkingIndex: Int = 99999
    
    var popularRestaurants: [GroupRestaurantsInfoModel] = groupRestaurantsInfo
    var restaurants: [GroupRestaurantsInfoModel] = groupRestaurantsInfo
    
    var filterPopularRestaurants: [GroupRestaurantsInfoModel] = []
    var filterRestaurants: [GroupRestaurantsInfoModel] = []
}

// 데이터 관련 메소드
extension HomeViewModel {
    func fetchRestaurantsData() {
        
        filterPopularRestaurants.removeAll()
        filterRestaurants.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
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
            
            self.didUpdateBottomSheetTableView?()
            self.didTest?()
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
    // 위치 정보 권한 체크
    func checkLocationAuthorization() {
        locationManager.checkUserDeviceLocationServiceAuthorization()
    }
    
    // 위치 권한 거부시 Alert
    func authorizationStatusChanged() {
        locationManager.onAuthorizationStatusChanged = { isAuthorized in
            if !isAuthorized {
                self.displayAlertHandler?()
            }
        }
    }
    
    // 위치 정보를 맵에 표시
    func updateCurrentLocation() {
        locationManager.didUpdateCurrentLocation = {
        
            let lat = self.locationManager.currentLocation?.latitude ?? 0.0
            let lon = self.locationManager.currentLocation?.longitude ?? 0.0
           
            self.onUpdateCurrentLocation?(lat, lon)
        }
    }
    
    func refreshCurrentLocation() {
        locationManager.refreshCurrentLocation()
    }
}

// 그룹 가입 여부 분기 처리
extension HomeViewModel {

    // API 오류로 임시 처리
    func checkJoinGroup() {
        UserInfoAPI.getLoginInfo { response in
            switch response {
            case .success(let success):
                self.didCompletedCheckJoinGroup?(false)
            case .failure(let failure):
                self.didCompletedCheckJoinGroup?(true)
            }
        }
    }
}
