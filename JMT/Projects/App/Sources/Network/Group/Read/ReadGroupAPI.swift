//
//  ReadGroupAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

struct ReadGroupAPI {
    static func fetchMyGroupAsync() async throws -> MyGroupResponse {
        let response = try await AF.request(ReadGroupTarget.fetchMyGroup, interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(MyGroupResponse.self)
            .value
        return response
    }
    
    static func fetchGroups(request: SearchGroupRequest) async throws -> SearchGroupResponse {
        let response = try await AF.request(ReadGroupTarget.fetchGroups(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SearchGroupResponse.self)
            .value
        return response
    }
}
