//
//  File.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

class MyPageUserInfo {
    
    static func getUserInfo(completion: @escaping (Result<MyPageUserLogin, Error>) -> Void) {
        let urlString = "https://api.jmt-matzip.dev/api/v1/user/info"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer 13", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let userInfo = try JSONDecoder().decode(MyPageUserLogin.self, from: data)
                completion(.success(userInfo))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

struct MyPageUserLogin: Codable {
    let data: UserData
    let message: String
    let code: String
    let id: Int
    let email, nickname, profileImg: String
}

struct UserData: Codable {
    let id: Int
    let email, nickname, profileImg: String
}
