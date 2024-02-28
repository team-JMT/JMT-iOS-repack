//
//  PopularRestaurantInfoCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import UIKit

class PopularRestaurantInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupData(model: GroupRestaurantsInfoModel?) {
        userNicknameLabel.text = model?.userNickName ?? ""
        restaurantNameLabel.text = model?.name ?? ""
        introduceLabel.text = model?.introduce ?? ""
        likeCountLabel.text = "\(model?.likeCount ?? 0)"
    }
}
