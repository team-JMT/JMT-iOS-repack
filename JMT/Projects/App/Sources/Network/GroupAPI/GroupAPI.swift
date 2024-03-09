//
//  GroupAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/02/28.
//

import Foundation
import Alamofire

struct GroupAPI {
    static func fetchMyGroupAsync() async throws -> [MyGroupData] {
        do  {
            let response = try await AF.request(GroupTarget.fetchMyGroup, interceptor: DefaultRequestInterceptor())
                .validate(statusCode: 200..<300)
                .serializingDecodable(MyGroupResponse.self)
                .value
            return response.data
        } catch {
            throw NetworkError.custom("fetchMyGroupAsync Error")
        }
    }
    
    static func updateSelectedGroupAsync(request: SelectedGroupRequest) async throws {
        do {
            let response = try await AF.request(GroupTarget.updateSelectedGroup(request), interceptor: DefaultRequestInterceptor())
                .validate(statusCode: 200..<300)
                .serializingDecodable(SelectedGroupResponse.self)
                .value
        } catch {
            throw NetworkError.custom("updateSelectedGroup Error")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    static func fetchMyGroup(completion: @escaping (Result<MyGroupResponse, NetworkError>) -> ()) {
        
        AF.request(GroupTarget.fetchMyGroup, interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MyGroupResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(.custom("fetchMyGroup Error")))
                }
            }
    }
    
    static func leaveGroup(request: MyGroupRequest, completion: @escaping () -> ()) {
        
        AF.request(GroupTarget.leaveGroup(request), interceptor: DefaultRequestInterceptor())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: MyGroupResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
