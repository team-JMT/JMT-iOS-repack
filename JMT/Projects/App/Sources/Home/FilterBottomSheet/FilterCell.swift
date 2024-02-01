//
//  FilterCell.swift
//  JMTeng
//
//  Created by PKW on 2024/01/27.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = JMTengAsset.gray100.color.cgColor
        self.contentView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupCell(filter: nil, index: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 12, right: 20))
    }
    
    func setupCell(filter: Int?, index: Int?) {
        
        
        
        switch filter {
        case 0:
            switch index {
            case 0:
                menuLabel.text = "가까운 순"
                menuImageView.isHidden = true
            case 1:
                menuLabel.text = "좋아요 순"
                menuImageView.isHidden = true
            case 2:
                menuLabel.text = "최신 순"
                menuImageView.isHidden = true
            default:
                return
            }
        case 1:
            switch index {
            case 0:
                menuLabel.text = "한식"
            case 1:
                menuLabel.text = "일식"
            case 2:
                menuLabel.text = "중식"
            case 3:
                menuLabel.text = "양식"
            case 4:
                menuLabel.text = "퓨전"
            case 5:
                menuLabel.text = "카페"
            case 6:
                menuLabel.text = "주점"
            default:
                return
            }
        case 2:
            switch index {
            case 0:
                menuLabel.text = "주류 가능"
            case 1:
                menuLabel.text = "주류 불가능/모름"
            default:
                return
            }
            
            
        default:
            return
        }
    }
}
