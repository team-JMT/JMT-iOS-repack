//
//  firstSegmentViewModel.swift
//  JMTeng
//
//  Created by 이지훈 on 3/14/24.
//

import Foundation
import UIKit
import Alamofire


//class firstSegmentViewModel {
//    
//    var onUserInfoLoaded: (() -> Void)?
//    var userProfileImage: UIImage?
//
//    
//    func fetchUserInfo() {
//        UserInfoAPI.getLoginInfo { response in
//            switch response {
//            case .success(let info):
//                print(1)
//            case .failure(let error):
//                print(2)
//            }
//        }
//    }
//    
//    func fetchUserProfileImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
//           AF.request(imageUrl).responseData { response in
//               switch response.result {
//               case .success(let data):
//                   let image = UIImage(data: data)
//                   DispatchQueue.main.async {
//                       completion(image)
//                   }
//               case .failure(let error):
//                   print(error)
//                   completion(nil)
//               }
//           }
//       }
    
//}

