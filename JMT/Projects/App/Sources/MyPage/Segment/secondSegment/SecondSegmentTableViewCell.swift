//
//  SecondSegmentTableViewCell.swift
//  JMTeng
//
//  Created by 이지훈 on 3/11/24.
//

import UIKit

class SecondSegmentTableViewCell: UITableViewCell{

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var Resturantexplanation: UILabel!
    @IBOutlet weak var mainCollection: UICollectionView!
    
    
    private var imageViews: [UIImageView] = []
    var imageUrls: [String] = [] // 이미지 URL 배열

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.cornerRadius = 12
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Set horizontal scroll
        mainCollection.collectionViewLayout = layout
        
        super.awakeFromNib()
        // Delegate와 DataSource 설정
        self.mainCollection.delegate = self
        self.mainCollection.dataSource = self
        self.mainCollection.reloadData()
    }
    
    
    
    func configure(with review: Review) {
        Resturantexplanation.text = review.reviewContent
        imageUrls = review.reviewImages
        mainCollection.reloadData()
    }

}


extension SecondSegmentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPageReviewCollectionViewCell", for: indexPath) as? myPageReviewCollectionViewCell else {
            fatalError("Unable to dequeue myPageReviewCollectionViewCell")
        }
        let imageName = imageUrls[indexPath.row]
        cell.configure(imageName: imageName)
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
        
    
}
