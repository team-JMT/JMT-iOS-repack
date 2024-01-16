//
//  AlbumCell.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        prepare(info: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(info: AlbumInfo?) {
        albumImageView.image = info?.thumbnail
        albumTitleLabel.text = info?.title
        albumCountLabel.text = "\(info?.numberOfItems ?? 0)"
    }
}
