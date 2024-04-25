//
//  CreateRestaurantsAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire
import UIKit

struct CreateRestaurantsAPI {
    // 맛집 위치 등록하기
    static func createRestaurantLocationAsync(request: CreateRestaurantLocationRequest) async throws -> CreateRestaurantLocationResponse {
        let response = try await AF.request(CreateRestaurantsTarget.createRestaurantLocation(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(CreateRestaurantLocationResponse.self)
            .value
        return response
    }
    
    // 맛집 등록하기
    static func createRestaurantAsync(request: CreateRestaurantRequest, images: [UIImage?]) async throws -> CreateRestaurantResponse {
        
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
        }, with: CreateRestaurantsTarget.createRestaurant(request), interceptor: DefaultRequestInterceptor())
        .validate(statusCode: 200..<300)
        .serializingDecodable(CreateRestaurantResponse.self)
        .value
        
        return response
    }
    
    // 리뷰 등록하기
    static func createRestaurantReviewAsync(request: CreateRestaurantReviewRequest, reviewContent: String, images: [UIImage]) async throws -> CreateRestaurantReviewResponse {
        
        let response = try await AF.upload(multipartFormData: { formData in
            formData.append(Data(reviewContent.utf8), withName: "reviewContent")
            
            for (index, image) in images.enumerated() {
                let resizeImage = image.resizeImage(widthSize: 300)
                let resultImage = resizeImage?.jpegData(compressionQuality: 0.5)
                
                if let imageData = resultImage {
                    formData.append(imageData, withName: "reviewImages", fileName: "\(index).jpg", mimeType: "image/jpeg")
                }
            }
        }, with: CreateRestaurantsTarget.createReview(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(CreateRestaurantReviewResponse.self)
            .value
        
        return response
    }
}
