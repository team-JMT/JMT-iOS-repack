//
//  PhotoInfo.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import Photos
import UIKit

enum SelectionOrder: Equatable {
    case none
    case selected(Int)
}

struct PhotoInfo {
    let phAsset: PHAsset
    var image: UIImage?
    let localIdentifier: String
    var albumIndex: Int
    var selectedIndex: Int
    var selectedOrder: SelectionOrder
}

