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
    
    let sortList = ["가까운 순", "좋아요 순", "최신 순"]
    let categoryList = ["한식", "일식", "중식", "양식", "퓨전", "카페", "주점", "기타"]
    let drinkingList = ["주류 가능", "주류 불가능/모름"]
    
    var sortType: SelectedSortType = .sort
    
    var originalCategoryIndex: Int = 99999
    var originalDrinkingIndex: Int = 99999
    
    var selectedSortIndex: Int = 0
    var selectedCategoryIndex: Int = 99999
    var selectedDrinkingIndex: Int = 99999
    
    var popularRestaurants = ["1","2","3","4","5"]  // [String]() //  
    var restaurants = ["1","2","3","4","5","6","7","8","9"]

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
        
//        CurrentLocationAPI.getCurrentLocation(request: CurrentLocationRequest(x: lon, y: lat)) { response in
//            switch response {
//            case .success(let locationData):
//                let address = self.extractSpecificParts(from: locationData.address)
//                completed(address)
//            case .failure(let error):
//                completed("검색 중")
//            }
//        }
    }
    
//    // 시/구/군, 동/읍/면 필터링
//    func extractSpecificParts(from address: String) -> String {
//        // "시", "구", "동"을 포함할 수 있는 정규 표현식 패턴
//        let pattern = "([가-힣]+(시|구|군))\\s?([가-힣]*(구)?)\\s+([가-힣]+(동|읍|면))"
//        let regex = try? NSRegularExpression(pattern: pattern)
//
//        var extractedParts: [String] = []
//
//        if let match = regex?.firstMatch(in: address, range: NSRange(address.startIndex..., in: address)) {
//            // "시" 부분 추출
//            if let cityRange = Range(match.range(at: 1), in: address) {
//                extractedParts.append(String(address[cityRange]))
//            }
//            // "구" 부분 추출 (있는 경우)
//            if let districtRange = Range(match.range(at: 3), in: address), !address[districtRange].isEmpty {
//                extractedParts.append(String(address[districtRange]))
//            }
//            // "동" 부분 추출
//            if let townRange = Range(match.range(at: 5), in: address) {
//                extractedParts.append(String(address[townRange]))
//            }
//        }
//
//        // "구"가 있으면 "시"를 제외, 없으면 모두 포함
//        if extractedParts.count > 2 && !extractedParts[1].isEmpty {
//            extractedParts.remove(at: 0) // "시" 제거
//        }
//
//        return extractedParts.joined(separator: " ")
//    }
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
            didUpdateBottomSheetTableView?()
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
