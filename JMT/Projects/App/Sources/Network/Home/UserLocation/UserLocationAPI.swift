//
//  UserLocationAPI.swift
//  JMTeng
//
//  Created by PKW on 2024/01/20.
//

import Foundation

struct UserLocationAPI {
    static func convertLocation(request: UserLocationRequest, completion: @escaping (Result<UserLocationModel, NetworkError>) -> ()) {
        
    }
    
    static func getSearchLocations(completion: @escaping ([String]) -> ()) {
        let locations = ["동대문1","동대문2","동대문3","동대문동","동대문동동","동대문동동동"]
        
        completion(locations)
    }
    
    static func getRecentSearchLoctaions() {
        
    }
}
