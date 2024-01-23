//
//  ProfileImageAPI.swift
//  App
//
//  Created by PKW on 2024/01/16.
//

import Foundation
import Alamofire

struct ProfileImageAPI {
    static func saveProfileImage(request: ProfileImageReqeust, completion: @escaping (Result<ProfileImageModel,NetworkError>) -> ()) {
    
        AF.upload(multipartFormData: { formData in
            if let imageData = Data(base64Encoded: request.imageStr) {
                formData.append(imageData, withName: "profileImg", fileName: "profile.png", mimeType: "image/png")
            }
        }, with: ProfileImageTarget.saveProfileImage(request), interceptor: DefaultRequestInterceptor())
        .validate(statusCode: 200..<300)
        .responseDecodable(of: ProfileImageResponse.self) { response in
            switch response.result {
            case .success(let response):
                print(response)
                completion(.success(response.toDomain))
            case .failure(let error):
                print("saveProfileImage 실패!!", error)
            }
        }
    }
    
    static func saveDefaultProfileImage(completion: @escaping (Result<ProfileImageModel, NetworkError>) -> ()) {
        AF.request(ProfileImageTarget.saveDefaultProfileImage, interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ProfileImageResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response.toDomain))
                case .failure(let error):
                    print("saveDefaultProfileImage 실패!!", error)
                }
            })
    }
}
