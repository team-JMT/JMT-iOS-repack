//
//  RecommendedMenuTagCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

protocol RecommendedMenuTagCellDelegate: AnyObject {
    func didTabDeleteButton(index: Int)
}

class RecommendedMenuTagCell: UICollectionViewCell {
   
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: RecommendedMenuTagCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 33 / 2
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = JMTengAsset.gray100.color.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configData(text: nil)
    }
    
    @IBAction func didTabDeleteButton(_ sender: UIButton) {
        delegate?.didTabDeleteButton(index: sender.tag)
    }
    
    func configData(text: String?) {
        tagLabel.text = text?.trimmingCharacters(in: CharacterSet(charactersIn: "#")) ?? ""
    }
}
