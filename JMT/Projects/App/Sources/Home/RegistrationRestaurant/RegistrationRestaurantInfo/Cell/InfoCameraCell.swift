//
//  CameraCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

class InfoCameraCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = JMTengAsset.gray100.color.cgColor
        
    }
}
