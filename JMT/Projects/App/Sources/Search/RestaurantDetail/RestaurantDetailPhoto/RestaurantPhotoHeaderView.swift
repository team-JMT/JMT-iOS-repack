//
//  RestaurantPhotoHeaderView.swift
//  JMTeng
//
//  Created by PKW on 3/22/24.
//

import UIKit

class RestaurantPhotoHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var photoCountLabel: UILabel!
    
    func setupCountLabel(count: Int) {
        photoCountLabel.text = "\(count)"
    }
}
