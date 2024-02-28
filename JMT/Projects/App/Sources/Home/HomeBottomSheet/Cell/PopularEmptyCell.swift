//
//  PopularEmptyCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/23.
//

import UIKit

protocol PopularEmptyCellDelegate: AnyObject {
    func registrationRestaurant()
}

class PopularEmptyCell: UICollectionViewCell {
    
    weak var delegate: PopularEmptyCellDelegate?
    
    @IBOutlet weak var registrationRestaurantButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registrationRestaurantButton.layer.cornerRadius = 8
    }
    
    @IBAction func didTabRegistrationRestaurantButton(_ sender: Any) {
        delegate?.registrationRestaurant()
    }
}
