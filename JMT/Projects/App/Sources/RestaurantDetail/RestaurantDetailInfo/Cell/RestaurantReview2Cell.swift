//
//  RestaurantReview2Cell.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import UIKit

class RestaurantReview2Cell: UICollectionViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewCommentLabel: UILabel!
    
    @IBOutlet weak var reviewPhotoCollectionView: UICollectionView!
    
    var photosUrl: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reviewPhotoCollectionView.delegate = self
        reviewPhotoCollectionView.dataSource = self
        
        userProfileImageView.layer.cornerRadius = 10
        self.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userProfileImageView.image = nil
        userNameLabel.text = nil
    }
    
    func setupData(reviewData: RestaurantReviewsModel?) {
        if let profileImageUrl = URL(string: reviewData?.reviewerImageUrl ?? "") {
            userProfileImageView.kf.setImage(with: profileImageUrl)
        } else {
            userProfileImageView.image = JMTengAsset.defaultProfileImage.image
        }
        
        userNameLabel.text = reviewData?.userName ?? ""
        reviewCommentLabel.text = reviewData?.reviewContent ?? ""
    }
}

extension RestaurantReview2Cell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RestaurantReview3Cell else { return UICollectionViewCell() }
        cell.setupReviewPhoto(url: photosUrl[indexPath.row])
        return cell
    }
    
}

extension RestaurantReview2Cell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 48)
    }
}
