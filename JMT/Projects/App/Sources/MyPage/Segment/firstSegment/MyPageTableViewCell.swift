//
//  MyPageTableViewCell.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import UIKit
import Alamofire

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
    
    func configure(with restaurant: Restaurant) {
        resturantLabel.text = restaurant.name
        grouplabel.text = restaurant.groupName
        categoryLable.text = restaurant.category
        MyNickname.text = restaurant.userNickName

        // 식당 이미지 로드
        if let imageUrlString = restaurant.restaurantImageURL, let imageUrl = URL(string: imageUrlString) {
            AF.request(imageUrl).responseData { [weak self] response in
                guard let self = self else { return }
                if case .success(let data) = response.result {
                    DispatchQueue.main.async {
                        self.myResturantImage.image = UIImage(data: data)
                    }
                }
            }
        } else {
            // URL이 nil인 경우, 대체 이미지 사용
            self.myResturantImage.image = UIImage(named: "dummyIcon")
            print(1)
        }


        // 사용자 프로필 이미지 로드
        if let userImageUrlString = restaurant.userProfileImageURL, let userImageUrl = URL(string: userImageUrlString) {
            AF.request(userImageUrl).responseData { [weak self] response in
                guard let self = self else { return }
                if case .success(let data) = response.result {
                    DispatchQueue.main.async {
                        self.myPageImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}
    
    

