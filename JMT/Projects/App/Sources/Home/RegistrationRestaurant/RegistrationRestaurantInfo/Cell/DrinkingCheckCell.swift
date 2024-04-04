//
//  DrinkingCheckCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

protocol DrinkingCheckCellDelegate: AnyObject {
    func didTabCheckButton(isSelected: Bool)
    func updateDrinkingComment(text: String)
}

class DrinkingCheckCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButtonContainerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    weak var delegate: DrinkingCheckCellDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentTextField.delegate = self
        commentTextField.isHidden = true
        
        checkButtonContainerView.layer.cornerRadius = 8
        checkButtonContainerView.layer.borderWidth = 2
        checkButtonContainerView.layer.borderColor = JMTengAsset.gray100.color.cgColor
        
        commentTextField.layer.borderColor = UIColor.systemBackground.cgColor
    }
    
    @IBAction func didTabCheckButton(_ sender: UIButton) {

        if let collectionView = self.superview as? UICollectionView {
            UIView.performWithoutAnimation {
                collectionView.performBatchUpdates {
                    
                    sender.isSelected = !sender.isSelected
                    
                    if sender.isSelected == true {
                        checkButtonContainerView.layer.borderColor = JMTengAsset.main500.color.cgColor
                        commentTextField.isHidden = false
                    } else {
                        checkButtonContainerView.layer.borderColor = JMTengAsset.gray100.color.cgColor
                        commentTextField.text = nil
                        commentTextField.isHidden = true
                    }
                }
            }
        }
        
        delegate?.didTabCheckButton(isSelected: sender.isSelected)
    }
    
    func setupEditData(str: String?) {
        checkButton.isSelected = true
        checkButtonContainerView.layer.borderColor = JMTengAsset.main500.color.cgColor
        commentTextField.text = str
        commentTextField.isHidden = false
    }
}

extension DrinkingCheckCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        let nextIndexPath = IndexPath(row: 0, section: 3)
        
        let collectionView = getCollectionView()

        if let nextCell = collectionView?.cellForItem(at: nextIndexPath) as? RecommendedMenuCell {
            nextCell.tagTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateDrinkingComment(text: textField.text ?? "")
    }
}
