//
//  RestaurantDetailFooterView.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

protocol RestaurantDetailFooterViewDelegate: AnyObject {
    func goToReviewTap()
}

class RestaurantDetailFooterView: UICollectionReusableView {
    weak var delegate: RestaurantDetailFooterViewDelegate?
    
    @IBAction func didTabMoreReviewButton(_ sender: Any) {
        delegate?.goToReviewTap()
    }
}
