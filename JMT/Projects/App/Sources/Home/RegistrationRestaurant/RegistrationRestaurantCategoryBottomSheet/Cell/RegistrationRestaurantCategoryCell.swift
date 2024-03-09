//
//  RegistrationRestaurantTypeCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

class RegistrationRestaurantCategoryCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = JMTengAsset.gray100.color.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryImageView.image = nil
        categoryNameLabel.text = nil
        
        containerView.layer.borderColor = JMTengAsset.gray100.color.cgColor
    }
    
    func setupData(category: String, isSelected: Bool, image: UIImage?) {
        
        containerView.layer.borderColor = isSelected ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
        
        categoryImageView.image = isSelected ? image?.withRenderingMode(.alwaysOriginal).withTintColor(JMTengAsset.main500.color) : image?.withRenderingMode(.alwaysOriginal).withTintColor(JMTengAsset.gray300.color)
        categoryNameLabel.text = category
    }
}
