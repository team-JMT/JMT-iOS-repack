//
//  MyPageTableViewCell.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import UIKit


class MyPageRegisterResturantTableViewCell: UITableViewCell {
  
 
    @IBOutlet weak var myResturantImage: UIImageView!
    
    @IBOutlet weak var resturantLabel: UILabel!
    @IBOutlet weak var grouplabel: UILabel!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var categoryLable: UILabel!
    
    @IBOutlet weak var myPageImage: UIImageView!
    
    @IBOutlet weak var MyNickname: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myResturantImage.layer.cornerRadius = 12

        groupView.layer.cornerRadius = 4

    }
    
    
    
}
