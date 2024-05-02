//
//  FirstSkeletonCell.swift
//  JMTeng
//
//  Created by PKW on 4/26/24.
//

import UIKit

class FirstSkeletonCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 20
    }
}
