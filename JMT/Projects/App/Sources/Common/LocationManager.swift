//
//  LocationManager.swift
//  JMTeng
//
//  Created by PKW on 2024/02/10.
//

import Foundation
import CoreLocation
import UIKit

final class LocationManager: CLLocationManager {
    
    static let shared = LocationManager()
    private var previousAuthorizationStatus: CLAuthorizationStatus?
    
    private override init() {
        super.init()
        
        self.delegate = self
        // 위치 정확도 (배터리 상황에 따라)
        self.desiredAccuracy = kCLLocationAccuracyBest
        // 초기 권한 상태 설정
        self.previousAuthorizationStatus = CLLocationManager.authorizationStatus()
    }

    var didUpdateLocations: (() -> Void)?
    var coordinate: CLLocationCoordinate2D?
    var isUpdatingLocation = false
    
    func startUpdateLocation() {
        isUpdatingLocation = false
        startUpdatingLocation()
    }
    
    func checkAuthorizationStatus() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied, .notDetermined:
            print("권한 거부")
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            print("권한 허용")
            return true
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        guard let location = locations.first, !isUpdatingLocation else { return }
        print("권한 위치 정보 업데이트")
        isUpdatingLocation = true
        coordinate = location.coordinate
        
        // 위치 데이터 처리
        didUpdateLocations?()
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("권한 설정 업데이트 실패 ====")
        self.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newStatus = manager.authorizationStatus
       
        isUpdatingLocation = false
        
        if newStatus != previousAuthorizationStatus {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("권한 설정 안함")
                self.stopUpdatingLocation()
            case .denied, .restricted:
                print("권한 설정 거부")
                self.stopUpdatingLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("권한 설정")
                startUpdatingLocation()
            }
            
            previousAuthorizationStatus = newStatus
        }
    }
}
