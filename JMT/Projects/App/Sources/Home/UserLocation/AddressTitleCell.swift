//
//  AddressTitleCell.swift
//  JMTeng
//
//  Created by PKW on 2024/01/20.
//

import UIKit

protocol AddressTitleCellDelegate: AnyObject {
    func didTapDeleteButton(at indexPath: IndexPath)
}

class AddressTitleCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addressNameLabel: UILabel!
    
    weak var delegate: AddressTitleCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        deleteButton.isHidden = false
        addressNameLabel.text = ""
    }
    
    @IBAction func didTabDeleteButton(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.didTapDeleteButton(at: indexPath)
        }
    }
}
