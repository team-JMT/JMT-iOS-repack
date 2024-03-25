//
//  myPageReviewCollectionViewCell.swift
//  JMTeng
//
//  Created by 이지훈 on 3/11/24.
//

import UIKit

class myPageReviewCollectionViewCell: UICollectionViewCell  {
    
    @IBOutlet weak var myPageImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        myPageImageView.layer.cornerRadius = 4
    }
    
    func configure(imageName: String) {
            myPageImageView.image = UIImage(named: imageName)
            myPageImageView.contentMode = .scaleAspectFill
            myPageImageView.clipsToBounds = true
        }
    
}


