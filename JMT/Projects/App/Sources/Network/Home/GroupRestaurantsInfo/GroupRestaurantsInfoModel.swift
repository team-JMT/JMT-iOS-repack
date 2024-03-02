//
//  GroupRestaurantsInfoModel.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import Foundation

struct GroupRestaurantsInfoModel {
    let id: Int
    let name: String
    let placeUrl: String
    let pictures: [String]
    let phone: String
    let address: String
    let roadAddress: String
    let x: Double
    let y: Double
    let restaurantImageUrl: String
    let introduce: String
    let category: String
    let userNickName: String
    let userProfileImageUrl: String
    let canDrinkLiquor: String
    let differenceInDistance: Int
    let likeCount: Int
    let comments: [CommentDatas]
}

struct CommentDatas {
    let id: Int
    let userId: Int
    let userNickname: String
    let userProfileImageUrl: String
    let comment: String
    let pictures: [String]
}


func generateDummyData(count: Int) -> [GroupRestaurantsInfoModel] {
    var restaurants: [GroupRestaurantsInfoModel] = []

    for id in 1...count {
        let picturesCount = Int.random(in: 0...5)
        let pictures = (0..<picturesCount).map { _ in "https://picsum.photos/1000/1000?random=\(Int.random(in: 1...100))" }

        let commentsCount = Int.random(in: 0...10)
        let comments = (0..<commentsCount).map { _ -> CommentDatas in
            let commentPicturesCount = Int.random(in: 0...5)
            let commentPictures = (0..<commentPicturesCount).map { _ in "https://picsum.photos/1000/1000?random=\(Int.random(in: 1...100))" }
            
            return CommentDatas(
                id: Int.random(in: 1...999),
                userId: Int.random(in: 1...999),
                userNickname: "Nickname \(Int.random(in: 1...999))",
                userProfileImageUrl: "https://picsum.photos/1000/1000?random=\(Int.random(in: 1...999))",
                comment: "Comment text \(Int.random(in: 1...999)) for restaurant \(id)",
                pictures: commentPictures
            )
        }

        let restaurant = GroupRestaurantsInfoModel(
            id: id,
            name: "Restaurant \(id)",
            placeUrl: "http://place.url/\(id)",
            pictures: pictures,
            phone: "010-0000-\(String(format: "%04d", id))",
            address: "Some address in Pyeongtaek",
            roadAddress: "Some road address in Pyeongtaek",
            x: Double.random(in: 126.7798...127.1234), // 경기도 평택시 범위
            y: Double.random(in: 36.9613...37.0997), // 경기도 평택시 범위
            restaurantImageUrl: "http://restaurant.image.url/rest\(id).jpg",
            introduce: "Introduce of restaurant \(id)",
            category: ["한식", "일식", "중식", "양식", "퓨전", "카페", "주점", "기타"].randomElement()!,
            userNickName: "User \(id)",
            userProfileImageUrl: "http://user.profile.url/user\(id).jpg",
            canDrinkLiquor: ["주류 가능", "주류 불가능/모름"].randomElement()!,
            differenceInDistance: Int.random(in: 100...20000),
            likeCount: Int.random(in: 0...500),
            comments: comments
        )

        restaurants.append(restaurant)
    }
    
    return restaurants
}

func generateDummyData2(count: Int) -> [GroupRestaurantsInfoModel] {
    var restaurants: [GroupRestaurantsInfoModel] = []

    for id in 1...count {
        let picturesCount = Int.random(in: 0...5)
        let pictures = (0..<picturesCount).map { _ in "https://picsum.photos/1000/1000?random=\(Int.random(in: 1...100))" }

        let commentsCount = Int.random(in: 0...10)
        let comments = (0..<commentsCount).map { _ -> CommentDatas in
            let commentPicturesCount = Int.random(in: 0...5)
            let commentPictures = (0..<commentPicturesCount).map { _ in "https://picsum.photos/1000/1000?random=\(Int.random(in: 1...100))" }
            
            return CommentDatas(
                id: Int.random(in: 1...999),
                userId: Int.random(in: 1...999),
                userNickname: "Nickname \(Int.random(in: 1...999))",
                userProfileImageUrl: "https://picsum.photos/1000/1000?random=\(Int.random(in: 1...999))",
                comment: "Comment text \(Int.random(in: 1...999)) for restaurant \(id)",
                pictures: commentPictures
            )
        }

        let restaurant = GroupRestaurantsInfoModel(
            id: id,
            name: "Restaurant \(id)",
            placeUrl: "http://place.url/\(id)",
            pictures: pictures,
            phone: "010-0000-\(String(format: "%04d", id))",
            address: "Some address in Pyeongtaek",
            roadAddress: "Some road address in Pyeongtaek",
            x: Double.random(in: 126.7798...127.1234), // 경기도 평택시 범위
            y: Double.random(in: 36.9613...37.0997), // 경기도 평택시 범위
            restaurantImageUrl: "http://restaurant.image.url/rest\(id).jpg",
            introduce: "Introduce of restaurant \(id)",
            category: ["한식", "중식", "양식", "퓨전", "카페", "주점", "기타"].randomElement()!, //"일식"
            userNickName: "User \(id)",
            userProfileImageUrl: "http://user.profile.url/user\(id).jpg",
            canDrinkLiquor: ["주류 가능"].randomElement()!, // , "주류 불가능/모름"
            differenceInDistance: Int.random(in: 100...20000),
            likeCount: Int.random(in: 0...500),
            comments: comments
        )

        restaurants.append(restaurant)
    }
    
    return restaurants
}


//let groupRestaurantsInfo = [
//    GroupRestaurantsInfoModel(id: 0,
//                              name: "맛집 1번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.060774581368,
//                              y: 37.0570933568603,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 1번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "중식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 가능",
//                              differenceInDistance: 1204,
//                              likeCount: 333),
//    GroupRestaurantsInfoModel(id: 2,
//                              name: "맛집 2번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.07456380065109,
//                              y: 37.05805144205608,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 2번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "한식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 가능",
//                              differenceInDistance: 293,
//                              likeCount: 22),
//    GroupRestaurantsInfoModel(id: 3,
//                              name: "맛집 3번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.070208872617,
//                              y: 37.053846085188,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 3번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "한식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 불가능/모름",
//                              differenceInDistance: 391,
//                              likeCount: 0),
//    GroupRestaurantsInfoModel(id: 4,
//                              name: "맛집 4번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.06112607068539,
//                              y: 37.05797983259642,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 4번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "중식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 불가능/모름",
//                              differenceInDistance: 1192,
//                              likeCount: 1),
//    GroupRestaurantsInfoModel(id: 5,
//                              name: "맛집 5번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.069702931384,
//                              y: 37.0538103405642,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 5번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "중식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 가능",
//                              differenceInDistance: 434,
//                              likeCount: 444),
//    GroupRestaurantsInfoModel(id: 6,
//                              name: "맛집 6번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.05709028539071,
//                              y: 37.05559219616072,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 6번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "한식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 불가능/모름",
//                              differenceInDistance: 1517,
//                              likeCount: 534),
//    GroupRestaurantsInfoModel(id: 7,
//                              name: "맛집 7번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.071321842108,
//                              y: 37.0538147847961,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 7번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "한식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 가능",
//                              differenceInDistance: 308,
//                              likeCount: 23),
//    GroupRestaurantsInfoModel(id: 8,
//                              name: "맛집 8번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.055610024562,
//                              y: 37.0545981136916,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 8번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "중식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 불가능/모름",
//                              differenceInDistance: 1651,
//                              likeCount: 346),
//    GroupRestaurantsInfoModel(id: 9,
//                              name: "맛집 9번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.06580050323018,
//                              y: 37.05489385794548,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 9번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "중식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 가능",
//                              differenceInDistance: 275,
//                              likeCount: 152),
//    GroupRestaurantsInfoModel(id: 10,
//                              name: "맛집 10번",
//                              placeUrl: "http://place.map.kakao.com/1971930784",
//                              phone: "031-662-9291",
//                              address: "경기 평택시 이충동 442-1",
//                              roadAddress: "경기 평택시 서정역로36번길 88",
//                              x: 127.07367527058469,
//                              y: 37.057709589314804,
//                              restaurantImageUrl: "",
//                              introduce: "맛집 10번 입니다. 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집 맛집",
//                              category: "한식",
//                              userNickName: "닉네임 ~_~",
//                              userProfileImageUrl: "",
//                              canDrinkLiquor: "주류 가능",
//                              differenceInDistance: 256,
//                              likeCount: 888)
//
//
//]
