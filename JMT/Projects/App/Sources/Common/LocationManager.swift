//
//  LocationManager.swift
//  JMTeng
//
//  Created by PKW on 2024/02/10.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager {
    
    var didUpdateLocations: ((CLLocationCoordinate2D?) -> Void)?
    var isUpdatingLocation = false
    
    override init() {
        super.init()
        
        self.delegate = self
        
        // 권한 요청
        self.requestWhenInUseAuthorization()
        
        // 위치 정확도 (배터리 상황에 따라)
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func fetchLocations() {
        isUpdatingLocation = false
        startUpdatingLocation()
    }
    
    func checkAuthorizationStatus() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
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
            let coordinate = location.coordinate
            
            print("권한 설정 업데이트 ====")
            
            didUpdateLocations?(coordinate)
            isUpdatingLocation = true
            self.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("권한 설정 업데이트 실패 ====")

        didUpdateLocations?(nil)
        self.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        isUpdatingLocation = false
        
        switch manager.authorizationStatus {
        case .notDetermined:
            print("권한 설정 안함")
            self.startUpdatingLocation()
        case .denied, .restricted:
            print("권한 설정 거부")
            self.startUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            print("권한 설정")
            self.startUpdatingLocation()
        }
    }
}
