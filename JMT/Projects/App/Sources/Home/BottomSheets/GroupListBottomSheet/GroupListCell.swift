//
//  GroupListCell.swift
//  JMTeng
//
//  Created by PKW on 3/9/24.
//

import UIKit
import Kingfisher

class GroupListCell: UITableViewCell {
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var selectedMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupImageView.layer.cornerRadius = 8

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        groupImageView.image = nil
        groupNameLabel.text = ""
        selectedMarkImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(imageUrl: String, name: String, isSelected: Bool) {
        if let url = URL(string: imageUrl) {
            groupImageView.kf.setImage(with: url)
        }
        
        groupNameLabel.text = name
        
        if isSelected {
            selectedMarkImageView.image = JMTengAsset.groupSelectedMark.image
        } else {
            selectedMarkImageView.image = nil
        }
    }
}
