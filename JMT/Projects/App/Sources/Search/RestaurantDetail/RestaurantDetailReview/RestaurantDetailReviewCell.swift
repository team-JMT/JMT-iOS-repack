//
//  RestaurantDetailReviewCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/03.
//

import UIKit

class RestaurantDetailReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    func configureCell(data: String?, index: Int) {
        
        reviewLabel.text = data
        
//        switch index {
//        case 0:
//            reviewImageView.isHidden = true
//        case 1:
//            reviewImageView.isHidden = true
//        case 3:
//            reviewImageView.isHidden = true
//        case 4:
//            reviewImageView.isHidden = true
//        case 5:
//            reviewImageView.isHidden = true
//        default:
//            reviewImageView.isHidden = false
//        }
    }
}
