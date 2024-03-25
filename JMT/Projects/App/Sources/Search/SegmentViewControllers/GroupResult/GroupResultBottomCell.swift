//
//  GroupResultBottomCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit

class GroupResultBottomCell: UICollectionViewCell {
    
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newGroupButton.setUnderline()
        bottomTitleLabel.setAttributedText(str: "원하는 그룹이 없으신가요?\n직접 원하는 그룹을 생성해 보세요!", lineHeightMultiple: 1.25, kern: -0.28, alignment: .left)
    }
    
    @IBAction func didTabNewGroupButton(_ sender: Any) {
        print("12312312")
    }
}
