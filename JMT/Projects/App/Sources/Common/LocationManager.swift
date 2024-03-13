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
    
    private override init() {
        super.init()
        
        self.delegate = self
        // 위치 정확도 (배터리 상황에 따라)
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
//
    var coordinate: CLLocationCoordinate2D?

    var didUpdateLocations: (() -> Void)?
    var isUpdatingLocation = false
    
    func fetchLocations() {
        isUpdatingLocation = false
        startUpdatingLocation()
    }
    
    func checkAuthorizationStatus() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("권한 설정 안함")
            return false
        case .restricted, .denied:
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
        
        if !isUpdatingLocation {
            guard let location = locations.first else { return }
            coordinate = location.coordinate
            
            print("권한 설정 업데이트 ====")
            
            didUpdateLocations?()
            
            isUpdatingLocation = true
            self.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("권한 설정 업데이트 실패 ====")

//        didUpdateLocations?(nil)
        self.stopUpdatingLocation()
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        
//        isUpdatingLocation = false
//
//        switch manager.authorizationStatus {
//        case .notDetermined:
//            print("권한 설정 안함")
//            self.stopUpdatingLocation()
//        case .denied, .restricted:
//            print("권한 설정 거부")
//            self.stopUpdatingLocation()
//        case .authorizedAlways, .authorizedWhenInUse:
//            print("권한 설정")
//            self.startUpdatingLocation()
//        }
//    }
}
