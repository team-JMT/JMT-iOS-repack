//
//  SecondHeaderView.swift
//  JMTeng
//
//  Created by PKW on 2024/01/25.
//

import UIKit

protocol SecondHeaderViewDelegate: AnyObject {
    func didTabFilter1Button()
    func didTabFilter2Button()
    func didTabFilter3Button()
}

class SecondHeaderView: UICollectionReusableView {
    
    weak var delegate: SecondHeaderViewDelegate?
    
    @IBOutlet weak var filterButton1: UIButton!
    @IBOutlet weak var filterButton2: UIButton!
    @IBOutlet weak var filterButton3: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterButton1.layer.borderColor = JMTengAsset.gray200.color.cgColor
        filterButton2.layer.borderColor = JMTengAsset.gray200.color.cgColor
        filterButton3.layer.borderColor = JMTengAsset.gray200.color.cgColor
        
        filterButton1.layer.borderWidth = 1
        filterButton2.layer.borderWidth = 1
        filterButton3.layer.borderWidth = 1
        
        filterButton1.layer.cornerRadius = filterButton1.frame.height / 2
        filterButton2.layer.cornerRadius = filterButton2.frame.height / 2
        filterButton3.layer.cornerRadius = filterButton3.frame.height / 2
    }
    
    @IBAction func didTabFilter1Button(_ sender: Any) {
        delegate?.didTabFilter1Button()
    }
    
    @IBAction func didTabFilter2Button(_ sender: Any) {
        delegate?.didTabFilter2Button()
    }
    
    @IBAction func didTabFilter3Button(_ sender: Any) {
        delegate?.didTabFilter3Button()
    }
    
}
