//
//  RestaurantPhotnAndReviewEmptyCell.swift
//  JMTeng
//
//  Created by PKW on 3/10/24.
//

import UIKit

class RestaurantPhotnAndReviewEmptyCell: UICollectionViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        commentLabel.text = nil
    }
    
    func setupUI(text: String) {
        commentLabel.text = text
    }
}
