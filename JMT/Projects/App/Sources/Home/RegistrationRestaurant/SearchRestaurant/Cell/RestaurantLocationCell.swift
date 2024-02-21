//
//  RestaurantLocationCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/20.
//

import UIKit

class RestaurantLocationCell: UITableViewCell {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(viewModel: SearchRestaurantsLocationModel?) {
        restaurantNameLabel.text = viewModel?.placeName ?? ""
        distanceLabel.text = (viewModel?.distance ?? "").distanceWithUnit()
        addressLabel.text = viewModel?.addressName ?? ""
    }

}
