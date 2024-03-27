//
//  myPageReviewCollectionViewCell.swift
//  JMTeng
//
//  Created by 이지훈 on 3/11/24.
//

import UIKit
import Kingfisher

class myPageReviewCollectionViewCell: UICollectionViewCell  {
    
    @IBOutlet weak var myPageImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myPageImageView.layer.cornerRadius = 4
    }
    
    func configure(imageName: String) {
        if let url = URL(string: imageName) {
            myPageImageView.kf.setImage(with: url)
        }
      
        myPageImageView.contentMode = .scaleAspectFill
        myPageImageView.clipsToBounds = true
    }
}


