//
//  RestaurantInfoCell.swift
//  JMTeng
//
//  Created by PKW on 3/15/24.
//

import UIKit

class RestaurantInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var groupProfileImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var restaurantCountLabel: UILabel!
    @IBOutlet weak var groupIntroduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupProfileImageView.layer.cornerRadius = 8
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        groupProfileImageView.image = nil
        groupNameLabel.text = nil
        memberCountLabel.text = nil
        restaurantCountLabel.text = nil
        groupIntroduceLabel.text = nil
    }
    
    func setupData(groupData: SearchGroupItems?) {
        groupProfileImageView.image = JMTengAsset.defaultProfileImage.image
        groupNameLabel.text = groupData?.groupName ?? ""
        memberCountLabel.text = "멤버 \(groupData?.memberCnt ?? 0)"
        restaurantCountLabel.text = "맛집 \(groupData?.restaurantCnt ?? 0)"
        groupIntroduceLabel.text = groupData?.groupIntroduce ?? ""
    }
}
