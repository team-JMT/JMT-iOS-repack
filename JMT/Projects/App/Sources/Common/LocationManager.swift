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



//final class LocationManager: CLLocationManager {
//    
//    var didUpdateLocation: ((CLLocationCoordinate2D?, Error?) -> Void)?
//    
//    override init() {
//        super.init()
//        
//        self.delegate = self
//        
//        // 권한 요청
//        self.requestWhenInUseAuthorization()
//        
//        // 위치 정확도 (배터리 상황에 따라)
//        self.desiredAccuracy = kCLLocationAccuracyBest
//    }
// 
//    func fetchLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
//        self.didUpdateLocation = completion
//    }
//    
//    func checkAuthorizationStatus() -> Bool {
//        let authorizationStatus: CLAuthorizationStatus = self.authorizationStatus
//        
//        switch authorizationStatus {
//        case .notDetermined, .denied, .restricted:
//            print("권한 거부됨")
//            return false
//        default:
//            print("권한 설정됨")
//            return true
//        }
//    }
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        let coordinate = location.coordinate
//    
//        print("권한 설정 ==== 업데이트")
//
//        self.didUpdateLocation?(coordinate,nil)
//        self.didUpdateLocation = nil
//        
//        self.stopUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        
//        print("위치 정보 업데이트 실패 ==== ")
//
//        self.didUpdateLocation?(nil,nil)
//        self.didUpdateLocation = nil
//        
//        self.stopUpdatingLocation()
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
//}
//
