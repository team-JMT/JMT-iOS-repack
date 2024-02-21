//
//  GroupResultBottomCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit

class GroupResultBottomCell: UICollectionViewCell {
    
    @IBOutlet weak var newGroupButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newGroupButton.setUnderline()
    }
    
    @IBAction func didTabNewGroupButton(_ sender: Any) {
        
    }
}
