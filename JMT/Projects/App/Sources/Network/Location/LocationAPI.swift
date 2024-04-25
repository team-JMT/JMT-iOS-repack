//
//  LocationAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

struct LocationAPI {
    
    static func getSearchLocations(request: SearchLocationRequest) async throws -> SearchLocationResponse {
        let response = try await AF.request(LocationTarget.getSearchLocations(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchLocationResponse.self)
            .value
        return response
    }
    
//    static func getSearchLocations(request: SearchLocationRequest, completion: @escaping (Result<[SearchLocationModel], NetworkError>) -> ()) {
//        
//        AF.request(LocationTarget.getSearchLocations(request), interceptor: DefaultRequestInterceptor())
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: SearchLocationResponse.self) { response in
//                switch response.result {
//                case .success(let response):
//                    completion(.success(response.toDomain))
//                case .failure(let error):
//                    print("123123")
//                }
//            }
//    }
    
    static func fetchCurrentLoctionAsync(request: CurrentLocationRequest) async throws -> CurrentLocationResponse {
        let response = try await AF.request(LocationTarget.getCurrentLocation(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(CurrentLocationResponse.self)
            .value
        return response
    }
}
