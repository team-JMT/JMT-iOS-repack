//
//  RestaurantPhotoCell.swift
//  JMTeng
//
//  Created by PKW on 3/10/24.
//

import UIKit
import Kingfisher

class RestaurantPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        restaurantImageView.image = nil
    }
    
    func setupData(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            restaurantImageView.kf.setImage(with: url)
        }
    }
}
