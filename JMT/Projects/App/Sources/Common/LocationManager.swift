//
//  LocationManager.swift
//  JMTeng
//
//  Created by PKW on 2024/02/10.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager() // 싱글톤 인스턴스

    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D?
    var hasReceivedLocationUpdate = false
    
    var onAuthorizationStatusChanged: ((Bool) -> Void)?
    var didUpdateCurrentLocation: (() -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
    
        let authorizationStatus: CLAuthorizationStatus
        
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("권한 설정 안함")
            locationManager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            print("권한 설정 거부 제한")
            onAuthorizationStatusChanged?(false)
            
        case .authorizedWhenInUse:
            print("권한 설정")
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 위치 정보를 성공적으로 가져왔을때
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard !hasReceivedLocationUpdate else { return }
        hasReceivedLocationUpdate = true
        
        if let coordinate = locations.last?.coordinate {
            currentLocation = coordinate
            didUpdateCurrentLocation?()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    // 위치 정보를 가져오는데 실패했을때
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오는데 실패: \(error.localizedDescription)")
    }
    
    func updateCurrentLocation(lat: Double, lon: Double) {
        currentLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        didUpdateCurrentLocation?()
    }
    
    func refreshCurrentLocation() {
        hasReceivedLocationUpdate = false
        locationManager.startUpdatingLocation()
    }
}
