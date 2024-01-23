//
//  ProfileImageAPI.swift
//  App
//
//  Created by PKW on 2024/01/16.
//

import Foundation
import Alamofire

struct ProfileImageAPI {
    static func saveProfileImage(request: ProfileImageReqeust, completion: @escaping (Result<ProfileImageResponse,NetworkError>) -> ()) {
    
        AF.upload(multipartFormData: { formData in
            if let imageData = Data(base64Encoded: request.imageStr) {
                formData.append(imageData, withName: "profileImg", fileName: "profile.png", mimeType: "image/png")
            }
        }, with: ProfileImageTarget.saveProfileImage(request)).responseDecodable(of: ProfileImageResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func saveDefaultProfileImage(completion: @escaping (Result<ProfileImageResponse, NetworkError>) -> ()) {
        AF.request(ProfileImageTarget.saveDefaultProfileImage)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: ProfileImageResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    static func getLoginInfo(completion: @escaping (Result<CurrentLoginInfoData,NetworkError>) -> ()) {
        
        AF.request(ProfileImageTarget.getLoginInfo).validate(statusCode: 200..<500)
            .responseDecodable(of: CurrentLoginInfoResponse<CurrentLoginInfoData>.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response.data))
                case .failure(let error):
                    print(error)
                }
            }
    }
}
