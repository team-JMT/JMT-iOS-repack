//
//  LocationManager.swift
//  JMTeng
//
//  Created by PKW on 2024/02/10.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager {
    
    private var didUpdateLocation: ((CLLocationCoordinate2D?, Error?) -> Void)?
    
    override init() {
        super.init()
        
        self.delegate = self
        
        // 권한 요청
        self.requestWhenInUseAuthorization()
        
        // 위치 정확도 (배터리 상황에 따라)
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
 
    func fetchLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.didUpdateLocation = completion
    }
    
    func checkAuthorizationStatus() -> Bool {
        let authorizationStatus: CLAuthorizationStatus = self.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined, .denied, .restricted:
            print("권한 거부됨")
            return false
        default:
            print("권한 설정됨")
            return true
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        
        print("위치 정보 업데이트 ==== ", coordinate)
        
        self.didUpdateLocation?(coordinate,nil)
        self.didUpdateLocation = nil
        
        self.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("위치 정보 업데이트 실패 ==== ")
        
        self.didUpdateLocation?(nil,nil)
        self.didUpdateLocation = nil
        
        self.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("권한 설정 안함")
            self.stopUpdatingLocation()
        case .denied, .restricted:
            print("권한 설정 거부")
            self.stopUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            print("권한 설정")
            self.startUpdatingLocation()
        }
    }
}


//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager() // 싱글톤 인스턴스
//
//    private let locationManager = CLLocationManager()
//
//    var currentLocation: CLLocationCoordinate2D?
//    var hasReceivedLocationUpdate = false
//
//    var onAuthorizationStatusChanged: ((Bool) -> Void)?
//    var didUpdateCurrentLocation: (() -> Void)?
//
//    private override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//    }
//
//    func checkUserDeviceLocationServiceAuthorization() {
//
//        let authorizationStatus: CLAuthorizationStatus
//
//        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
//        if #available(iOS 14.0, *) {
//            authorizationStatus = locationManager.authorizationStatus
//        }else {
//            authorizationStatus = CLLocationManager.authorizationStatus()
//        }
//
//        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
//        checkUserCurrentLocationAuthorization(authorizationStatus)
//    }
//
//    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
//
//        switch status {
//        case .notDetermined:
//            print("권한 설정 안함")
//            locationManager.requestWhenInUseAuthorization()
//            hasReceivedLocationUpdate = false
//
//        case .denied, .restricted:
//            print("권한 설정 거부 제한")
//            onAuthorizationStatusChanged?(false)
//            hasReceivedLocationUpdate = false
//        case .authorizedWhenInUse:
//            print("권한 설정")
//            locationManager.startUpdatingLocation()
//            hasReceivedLocationUpdate = true
//        default:
//            print("Default")
//            hasReceivedLocationUpdate = false
//        }
//    }
//
//    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("1")
//        //checkUserDeviceLocationServiceAuthorization()
//    }
//
//    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("2")
//        //checkUserDeviceLocationServiceAuthorization()
//    }
//
//    // 위치 정보를 성공적으로 가져왔을때
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard !hasReceivedLocationUpdate else { return }
//        hasReceivedLocationUpdate = true
//
//        if let coordinate = locations.last?.coordinate {
//            currentLocation = coordinate
//            didUpdateCurrentLocation?()
//        }
//
//        locationManager.stopUpdatingLocation()
//    }
//
//    // 위치 정보를 가져오는데 실패했을때
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("위치 정보를 가져오는데 실패: \(error.localizedDescription)")
//    }
//
//    func updateCurrentLocation(lat: Double, lon: Double) {
//        currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        didUpdateCurrentLocation?()
//    }
//
//    func refreshCurrentLocation() {
//        hasReceivedLocationUpdate = false
//        locationManager.startUpdatingLocation()
//    }
//}
