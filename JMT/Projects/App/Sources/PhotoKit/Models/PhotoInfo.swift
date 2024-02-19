//
//  PhotoInfo.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import Photos
import UIKit

// MARK: 앨범에서 선택한 이미지 다시 앨범에 표시하기
enum SelectionOrder: Equatable {
    case none
    case selected(Int)
}

struct PhotoInfo {
    let phAsset: PHAsset
    var image: UIImage?
    let localIdentifier: String
    let albumIndex: Int
    let selectedIndex: Int
    var selectedOrder: SelectionOrder
}
