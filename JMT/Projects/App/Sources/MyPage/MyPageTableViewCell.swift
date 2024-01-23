//
//  MyPageTableViewCell.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import UIKit


class MyPageTableViewCell: UITableViewCell {
    @IBOutlet weak var myPageImage: UIImageView!
    @IBOutlet weak var mapageResturantName: UILabel!

    func configure(with data: DummyDataType) {
        myPageImage.image = UIImage(named: data.image)
        mapageResturantName.text = data.labelText
    }
}
