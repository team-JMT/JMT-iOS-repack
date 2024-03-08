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
       setupCell(viewModel: nil, row: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 12, right: 20))
    }
    
    func setupCell(viewModel: HomeViewModel?, row: Int?) {
        let menuOptions: [(text: String, isHideImage: Bool, image: UIImage?)] = {
            switch viewModel?.sortType {
            case .sort:
                return [("가까운 순", true, nil),
                        ("최신 순", true, nil)]
            case .category:
                return [("한식", false, JMTengAsset.category1.image),
                        ("일식", false, JMTengAsset.category2.image),
                        ("중식", false, JMTengAsset.category3.image),
                        ("양식", false, JMTengAsset.category4.image),
                        ("퓨전", false, JMTengAsset.category5.image),
                        ("카페", false, JMTengAsset.category6.image),
                        ("주점", false, JMTengAsset.category7.image),
                        ("기타", false, JMTengAsset.category8.image)]
            case .drinking:
                return [("주류 가능", false, JMTengAsset.category7.image),
                        ("주류 불가능/모름", false, JMTengAsset.category7.image)]
            case .none:
                return []
            }
        }()
        
        guard let idx = row, idx < menuOptions.count else { return }
        
        menuLabel.text = menuOptions[idx].text
        menuImageView.isHidden = menuOptions[idx].isHideImage
        menuImageView.image = menuOptions[idx].image?.withRenderingMode(.alwaysTemplate)
        
        switch viewModel?.sortType {
        case .sort:
            self.contentView.layer.borderColor = viewModel?.selectedSortIndex == row ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
        case .category:
            self.contentView.layer.borderColor = viewModel?.selectedCategoryIndex == row ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
            menuImageView.tintColor = viewModel?.selectedCategoryIndex == row ? JMTengAsset.main500.color : JMTengAsset.gray200.color
        case .drinking:
            self.contentView.layer.borderColor = viewModel?.selectedDrinkingIndex == row ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
            menuImageView.tintColor = viewModel?.selectedDrinkingIndex == row ? JMTengAsset.main500.color : JMTengAsset.gray200.color
        case .none:
            return
        }
    }
}
