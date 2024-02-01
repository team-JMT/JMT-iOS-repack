//
//  SearchResultCell.swift
//  JMTeng
//
//  Created by PKW on 2024/01/31.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    func setupData(text: String) {
        searchResultLabel.text = text
    }
}
