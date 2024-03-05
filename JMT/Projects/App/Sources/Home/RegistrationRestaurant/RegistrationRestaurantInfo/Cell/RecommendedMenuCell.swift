//
//  RecommendedMenuCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

protocol RecommendedMenuCellDelegate: AnyObject {
    func updateTag(text: String)
}

class RecommendedMenuCell: UICollectionViewCell {
    
    @IBOutlet weak var tagTextField: UITextField!
    
    weak var delegate: RecommendedMenuCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        tagTextField.delegate = self
    }
}

extension RecommendedMenuCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.updateTag(text: textField.text ?? "")
        return true
    }
}
