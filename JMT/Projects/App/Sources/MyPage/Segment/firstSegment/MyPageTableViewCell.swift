//
//  MyPageTableViewCell.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import UIKit
import Alamofire
import Kingfisher

class MyPageRegisterResturantTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var myResturantImage: UIImageView!
    
    @IBOutlet weak var resturantLabel: UILabel!
    @IBOutlet weak var grouplabel: UILabel!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var categoryLable: UILabel!
    
    @IBOutlet weak var myPageImage: UIImageView!
    
    @IBOutlet weak var MyNickname: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myResturantImage.layer.cornerRadius = 12
        myPageImage.layer.cornerRadius = myPageImage.frame.size.width / 2
        myPageImage.clipsToBounds = true
        groupView.layer.cornerRadius = 4
        
    }
    
    func configureData(with model: OtherUserRestaurantsModelItems?) {
        resturantLabel.text = model?.name ?? ""
        grouplabel.text = model?.groupName ?? ""
        categoryLable.text = model?.category ?? ""
        MyNickname.text = model?.userNickName ?? ""
        
        if let url = URL(string: model?.restaurantImageUrl ?? "") {
            myResturantImage.kf.setImage(with: url)
        } else {
            myResturantImage.image = JMTengAsset.resultEmptyImage.image
        }
        
        if let url = URL(string: model?.userProfileImageUrl ?? "") {
            myPageImage.kf.setImage(with: url)
        } else {
            myPageImage.image = JMTengAsset.defaultProfileImage.image
        }
    }
    
    func configure(with restaurant: Restaurant?) {
        resturantLabel.text = restaurant?.name ?? ""
        grouplabel.text = restaurant?.groupName ?? ""
        categoryLable.text = restaurant?.category ?? ""
        MyNickname.text = restaurant?.userNickName ?? ""
        
        if let imageUrlString = restaurant?.restaurantImageURL, let imageUrl = URL(string: imageUrlString) {
            myResturantImage.kf.setImage(
                with: imageUrl,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Kingfisher Success: Image loaded from \(value.source.url?.absoluteString ?? "Unknown")")
                    case .failure(let error):
                        print("Kingfisher Failure: \(error.localizedDescription)")
                    }
                }
            )
            
        } else {
            myResturantImage.image = UIImage(named: "dummyIcon")
            print("Fallback to dummyIcon due to invalid URL")
        }

        
        // 사용자 프로필 이미지 로드 - Kingfisher를 사용
        if let userImageUrlString = restaurant?.userProfileImageURL, let userImageUrl = URL(string: userImageUrlString) {
            myPageImage.kf.setImage(with: userImageUrl, placeholder: UIImage(named: "defaultProfile"))
        } else {
            myPageImage.image = UIImage(named: "defaultProfile")
        }
    }

}





