//
//  PopularRestaurantCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import UIKit

class PopularRestaurantCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupData(model: GroupRestaurantsInfoModel?) {
        userNicknameLabel.text = model?.userNickName ?? ""
        restaurantNameLabel.text = model?.name ?? ""
    }
}



