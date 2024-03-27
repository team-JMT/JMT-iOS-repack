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
    
    @IBOutlet weak var groupId: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var resturantName: UILabel!
    private var imageViews: [UIImageView] = []
    var imageUrls: [String] = [] // 이미지 URL 배열
    
    var reviewImagesURL: [String] = []
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        Resturantexplanation.text = nil
        resturantName.text = nil
        reviewImagesURL = []
    }
    
    func configure(with review: Review?) {
        Resturantexplanation.text = review?.reviewContent ?? ""
        resturantName.text = review?.groupName ?? ""

        reviewImagesURL = review?.reviewImages ?? []
    }
}

extension SecondSegmentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPageReviewCollectionViewCell", for: indexPath) as? myPageReviewCollectionViewCell else {
            fatalError("Unable to dequeue myPageReviewCollectionViewCell")
        }
        let imageName = reviewImagesURL[indexPath.row]
        cell.configure(imageName: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
}
