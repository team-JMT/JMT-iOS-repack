//
//  RestaurantReviewPhoto2Cell.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import UIKit

class RestaurantReviewPhoto2Cell: UICollectionViewCell {
   
    @IBOutlet weak var reviewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reviewImageView.image = nil
        
    }
    
    func setupData(imageUrl: String) {
        print(imageUrl)
      
        if let url = URL(string: imageUrl) {
            reviewImageView.kf.setImage(with: url)
        }
    }
}
