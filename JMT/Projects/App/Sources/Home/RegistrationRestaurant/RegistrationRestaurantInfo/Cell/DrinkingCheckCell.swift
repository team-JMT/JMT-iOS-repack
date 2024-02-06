//
//  DrinkingCheckCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

class DrinkingCheckCell: UICollectionViewCell {
    
    
    @IBOutlet weak var checkButtonContainerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkButtonContainerView.layer.cornerRadius = 8
        checkButtonContainerView.layer.borderWidth = 2
        checkButtonContainerView.layer.borderColor = JMTengAsset.gray100.color.cgColor
        
        commentTextField.layer.borderColor = UIColor.systemBackground.cgColor
    }
    
    @IBAction func didTabCheckButton(_ sender: Any) {
        
    }
}
