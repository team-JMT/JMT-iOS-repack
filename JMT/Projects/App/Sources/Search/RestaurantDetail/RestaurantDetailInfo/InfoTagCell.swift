//
//  InfoTagCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/03.
//

import UIKit

class InfoTagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagButton: UIButton!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 33 / 2
        self.contentView.layer.borderColor = JMTengAsset.gray200.color.cgColor
        self.contentView.layer.borderWidth = 1
    }
}
