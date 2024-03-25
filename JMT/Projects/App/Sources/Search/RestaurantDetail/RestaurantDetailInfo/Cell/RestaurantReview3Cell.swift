//
//  RestaurantReview3Cell.swift
//  JMTeng
//
//  Created by PKW on 3/23/24.
//

import UIKit
import Kingfisher

class RestaurantReview3Cell: UICollectionViewCell {
    
    @IBOutlet weak var reviewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        reviewImageView.image = nil
    }
    
    func setupReviewPhoto(url: String?) {
        if let url = URL(string: url ?? "")  {
            reviewImageView.kf.setImage(with: url)
        }
    }
}
