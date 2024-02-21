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
        let menuOptions: [(text: String, isHideImage: Bool)] = {
            switch viewModel?.sortType {
            case .sort:
                return [("가까운 순", true), ("좋아요 순", true), ("최신 순", true)]
            case .category:
                return [("한식", false), ("일식", false), ("중식", false), ("양식", false), ("퓨전", false), ("카페", false), ("주점", false), ("기타", false)]
            case .drinking:
                return [("주류 가능", false), ("주류 불가능/모름", false)]
            case .none:
                return []
            }
        }()
        
        guard let idx = row, idx < menuOptions.count else { return }
        
        menuLabel.text = menuOptions[idx].text
        menuImageView.isHidden = menuOptions[idx].isHideImage
        
        switch viewModel?.sortType {
        case .sort:
            self.contentView.layer.borderColor = viewModel?.selectedSortIndex == row ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
        case .category:
            self.contentView.layer.borderColor = viewModel?.selectedCategoryIndex == row ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
        case .drinking:
            self.contentView.layer.borderColor = viewModel?.selectedDrinkingIndex == row ? JMTengAsset.main500.color.cgColor : JMTengAsset.gray100.color.cgColor
        case .none:
            return
        }
    }
}
