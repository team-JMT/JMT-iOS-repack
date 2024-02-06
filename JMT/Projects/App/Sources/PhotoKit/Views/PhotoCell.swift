//
//  PhotoCell.swift
//  App
//
//  Created by PKW on 2024/01/12.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoCircleImageView: UIImageView!
    @IBOutlet weak var highlightedView: UIView!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        highlightedView.layer.borderWidth = 5.0
        highlightedView.layer.borderColor = UIColor.main600?.cgColor
        orderView.layer.cornerRadius = 20 / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        prepare(info: nil)
    }
    
    func prepare(info: PhotoInfo?) {
        photoImageView.image = info?.image
        
        if case let .selected(order) = info?.selectedOrder {
            highlightedView.isHidden = false
            orderLabel.text = String(order)
        } else {
            highlightedView.isHidden = true
        }
    }
}
