//
//  PhotoInfo.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import Photos
import UIKit

enum SelectionOrder {
    case none
    case selected(Int)
}

struct PhotoInfo {
    let phAsset: PHAsset
    var image: UIImage?
    let selectedOrder: SelectionOrder
}

