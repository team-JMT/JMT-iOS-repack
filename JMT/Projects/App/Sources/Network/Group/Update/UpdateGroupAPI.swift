//
//  UpdateGroupAPI.swift
//  JMTeng
//
//  Created by PKW on 4/25/24.
//

import Foundation
import Alamofire

struct UpdateGroupAPI {
    @discardableResult
    static func updateSelectedGroupAsync(request: SelectedGroupRequest) async throws -> SelectedGroupResponse {
        let response = try await AF.request(UpdateGroupTarget.updateSelectedGroup(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .serializingDecodable(SelectedGroupResponse.self)
            .value
        return response
    }
}
