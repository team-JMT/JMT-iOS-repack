//
//  SearchResultEmptyCell.swift
//  JMTeng
//
//  Created by PKW on 3/18/24.
//

import UIKit

class SearchResultEmptyCell: UICollectionViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var createGroupButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        createGroupButton.layer.cornerRadius = 8
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        commentLabel.text = nil
    }
    
    func setupCommentLabel(str: String, isHideButton: Bool) {
        commentLabel.text = str
        createGroupButton.isHidden = isHideButton
    }
}
