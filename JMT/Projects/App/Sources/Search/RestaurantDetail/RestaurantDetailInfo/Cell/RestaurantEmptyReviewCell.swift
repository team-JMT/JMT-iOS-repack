//
//  RestaurantEmptyReviewCell.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import UIKit

class RestaurantEmptyReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        commentLabel.text = nil
        
    }
    
    func setupData(comment: String) {
        commentLabel.text = comment
    }
}
