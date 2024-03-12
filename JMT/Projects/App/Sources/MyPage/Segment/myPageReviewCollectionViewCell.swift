//
//  myPageReviewCollectionViewCell.swift
//  JMTeng
//
//  Created by 이지훈 on 3/11/24.
//

import UIKit

class myPageReviewCollectionViewCell: UICollectionViewCell  {
    
    @IBOutlet weak var myPageImageView: UIImageView!
    
   // var imageNames: [String] = []
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        // imagesCollectionView 설정
//        imagesCollectionView.delegate = self
//        imagesCollectionView.dataSource = self
//        imagesCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
//    }
    
    func configure(imageName: String) {
            myPageImageView.image = UIImage(named: imageName)
            myPageImageView.contentMode = .scaleAspectFill
            myPageImageView.clipsToBounds = true
        }
    
}


