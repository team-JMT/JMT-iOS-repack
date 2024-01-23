//
//  PhotoKitConfiguration.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import Photos
import UIKit

var photoKitConfig: PhotoKitConfiguration {
    return PhotoKitConfiguration.shared
}

struct PhotoKitConfiguration {
    static var shared: PhotoKitConfiguration = PhotoKitConfiguration()
    init() { }
    
    var library = PhotoKitConfigLibrary()
}

struct PhotoKitConfigLibrary {
   
    // 다중 선택
    var defaultMultipleSelection = false
    
    // 최대 선택 가능한 수
    var maxNumberOfItems = 1
    
    // 최소 선택 가능한 수
    var minNumberOfItems = 1
    
    // 컬렉션뷰 가로방향의 아이템 수
    var numberOfItemsInRow: Double = 3.0
    
    // 사진간 간격
    var cellSpace: Double = 1.0
    
    private var length: Double {
        return (UIScreen.main.bounds.size.width - cellSpace * (numberOfItemsInRow - 1)) / numberOfItemsInRow
    }
    
    var cellSize: CGSize {
        return CGSize(width: length, height: length)
    }
    
    let scale = UIScreen.main.scale
}
