//
//  PhotoCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/05.
//

import UIKit

protocol InfoPhotoCellDelegate: AnyObject {
    func didTabDeleteButton(in cell: UICollectionViewCell)
}

class InfoPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: InfoPhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        menuImageView.layer.cornerRadius = 8
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        deleteButton.tag = 0
    }
    
    @IBAction func didTabDeleteButton(_ sender: UIButton) {
        delegate?.didTabDeleteButton(in: self)
    }
}
