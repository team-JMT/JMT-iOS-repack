//
//  SecondSegmentTableViewCell.swift
//  JMTeng
//
//  Created by 이지훈 on 3/11/24.
//

import UIKit

class SecondSegmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ResturantImage: UIImageView!
    
    @IBOutlet weak var Resturantexplanation: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
