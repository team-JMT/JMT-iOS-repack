//
//  TagCollectionViewCell.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit

protocol TagCollectionViewCellDelegate: AnyObject {
    func didTabDeleteButton(index: Int)
}

class TagCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: TagCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 29 / 2
        layer.borderWidth = 1
        layer.borderColor = JMTengAsset.gray200.color.cgColor
        
    }

    func setupData(text: String) {
        tagNameLabel.text = text
    }
    
    @IBAction func didTabDeleteButton(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        delegate?.didTabDeleteButton(index: button.tag)
    }
}
