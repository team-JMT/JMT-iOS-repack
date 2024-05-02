//
//  RestaurantMoreMenuCell.swift
//  JMTeng
//
//  Created by PKW on 3/27/24.
//

import UIKit

class RestaurantMoreMenuCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = JMTengAsset.gray100.color.cgColor
        contentView.layer.borderWidth = 2
    }
    
    override func prepareForReuse() {
        menuImageView.image = nil
        menuTitleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 12, right: 20))
    }

    func setupUI(index: Int) {
        switch index{
        case 0:
            menuImageView.image = JMTengAsset.moreMenuEditImage.image
            menuTitleLabel.text = "수정하기"
        case 1:
            menuImageView.image = JMTengAsset.moreMenuDeleteImage.image
            menuTitleLabel.text = "삭제하기"
//        case 2:
//            menuImageView.image = JMTengAsset.moreMenuShareImage.image
//            menuTitleLabel.text = "공유하기"
        default:
            return
        }
    }
}
