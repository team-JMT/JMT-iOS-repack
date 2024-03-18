//
//  ReviewPhotoCell.swift
//  JMTeng
//
//  Created by PKW on 3/19/24.
//

import UIKit

protocol ReviewPhotoCellDelegate: AnyObject {
    func didTabDeleteButton(in cell: UICollectionViewCell)
}

class ReviewPhotoCell: UICollectionViewCell {
   
    weak var delegate: ReviewPhotoCellDelegate?
    @IBOutlet weak var reviewPhotoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reviewPhotoImageView.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func setupReviewPhoto(image: UIImage) {
        reviewPhotoImageView.image = image
    }
    
    @IBAction func didTabDeleteButton(_ sender: Any) {
        delegate?.didTabDeleteButton(in: self)
    }
}
