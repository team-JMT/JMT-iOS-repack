//
//  RegistrationRestaurantAPI.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import Foundation
import Alamofire
import UIKit

struct RegistrationRestaurantAPI {
    static func registrationRestaurantLocationAsync(request: RegistrationRestaurantLocationRequest) async throws -> RegistrationRestaurantLocationResponse {
        
        let response = try await AF.request(RegistrationRestaurantTarget.registrationRestaurantLocation(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(RegistrationRestaurantLocationResponse.self)
            .value
        return response
    }
    
    static func registrationRestaurantAsync(request: RegistrationRestaurantRequest, images: [UIImage?]) async throws -> RegistrationRestaurantResponse {
        
        let response = try await AF.upload(multipartFormData: { formData in
            formData.append(Data(request.name.utf8), withName: "name")
            formData.append(Data(request.introduce.utf8), withName: "introduce")
            formData.append(Data("\(request.categoryId)".utf8), withName: "categoryId")
            formData.append(Data("\(request.canDrinkLiquor)".utf8), withName: "canDrinkLiquor")
            formData.append(Data(request.goWellWithLiquor.utf8), withName: "goWellWithLiquor")
            formData.append(Data(request.recommendMenu.utf8), withName: "recommendMenu")
            formData.append(Data("\(request.restaurantLocationId)".utf8), withName: "restaurantLocationId")
            formData.append(Data("\(request.groupId)".utf8), withName: "groupId")
            
            
            for (index, image) in images.enumerated() {
                let resizeImage = image?.resizeImage(widthSize: 300)
                let resultImage = resizeImage?.jpegData(compressionQuality: 0.5)
               
                if let imageData = resultImage {
                    formData.append(imageData, withName: "pictures", fileName: "\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, with: RegistrationRestaurantTarget.registrationRestaurant(request), interceptor: DefaultRequestInterceptor())
        .validate(statusCode: 200..<300)
        .serializingDecodable(RegistrationRestaurantResponse.self)
        .value
        
        return response
    }
    
    static func registrationReviewAsync(request: RegistrationReviewRequest, reviewContent: String, images: [UIImage]) async throws -> RegistrationReviewResponse {
        
        let response = try await AF.upload(multipartFormData: { formData in
            formData.append(Data(reviewContent.utf8), withName: "reviewContent")
            
            for (index, image) in images.enumerated() {
                let resizeImage = image.resizeImage(widthSize: 300)
                let resultImage = resizeImage?.jpegData(compressionQuality: 0.5)
                
                if let imageData = resultImage {
                    formData.append(imageData, withName: "reviewImages", fileName: "\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, with: RegistrationRestaurantTarget.registrationReview(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(RegistrationReviewResponse.self)
            .value
        
        return response
    }
    
    static func editRestaurantInfo(request: EditRestaurantInfoRequest) async throws -> EditRestaurantInfoResponse {
        let response = try await AF.request(RegistrationRestaurantTarget.editRestaurantInfo(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(EditRestaurantInfoResponse.self)
            .value
        return response
    }
}
