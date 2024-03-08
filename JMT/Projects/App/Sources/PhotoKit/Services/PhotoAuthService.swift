//
//  PhotoAuthService.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import Photos
import UIKit

protocol PhotoAuthService: AnyObject {
    var authorizationStatus: PHAuthorizationStatus { get }
    var isAuthorizationLimited: Bool { get }
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void)
}

extension PhotoAuthService {
    
    // 권한 종류
    var isAuthorizationLimited: Bool {
        authorizationStatus == .limited
    }
    
//    // 사진 설정 화면으로 이동
//    fileprivate func goToSetting() {
//        if let bundleIdentifier = Bundle.main.bundleIdentifier,
//            let appSettingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
//            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
//        }
//    }
}

final class DefaultPhotoAuthService: PhotoAuthService {
    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    // 권환 확인
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void) {
        
        switch authorizationStatus {
        case .authorized:
            completion(.success(()))
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "111", code: 1, userInfo: [NSLocalizedDescriptionKey: "111"])))
            }
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(.success(()))
                    default:
                        completion(.failure(NSError(domain: "222", code: 2, userInfo: [NSLocalizedDescriptionKey: "222"])))
                    }
                }
            }
            
        default:
            completion(.failure(NSError(domain: "333", code: 3, userInfo: [NSLocalizedDescriptionKey: "333"])))
        }
    }
}


/*
 
 guard authorizationStatus != .authorized else {
     completion(.success(()))
     return
 }
 
 guard authorizationStatus != .denied else {
     DispatchQueue.main.async {
         self.goToSetting()
     }
     
     completion(.success(()))
     return
 }
 
 guard authorizationStatus == .notDetermined else {
     completion(.failure(.init()))
     return
 }
 
 PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
     DispatchQueue.main.async {
         completion(.success(()))
     }
 }
 */
