//
//  NetworkError.swift
//  App
//
//  Created by PKW on 2023/12/29.
//

import Foundation

enum NetworkError: Error {
    case googleLoginError
    case appleLoginError
    case idTokenError
    case custom(String) // 기타 에러 메시지를 위한 커스텀 케이스

    var localizedDescription: String {
        switch self {
        case .googleLoginError:
            return "구글 로그인 에러 입니다."
        case .appleLoginError:
            return "애플 로그인 에러 입니다."
        case .idTokenError:
            return "IdToken 에러 입니다."
        case .custom(let message):
            return message
        }
    }
}

enum RestaurantError: Error {
    case fetchRecentRestaurantsAsyncError
    case fetchGroupRestaurantsAsyncError
    case fetchMapIncludedRestaurantsAsyncError
    case fetchCurrentAddressAsyncError
    case fetchJoinGroupError
    case updateSelectedGroupError
    case registrationRestaurantLocationError
    case registrationRestaurantAsyncError
    
    // SearchViewModel Error
    case fetchGroupsAsyncError
    case fetchRestaurantsAsyncError
    case fetchOutBoundRestaurantsAsyncError
}
