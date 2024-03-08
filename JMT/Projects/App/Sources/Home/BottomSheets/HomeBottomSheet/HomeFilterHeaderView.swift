//
//  SecondHeaderView.swift
//  JMTeng
//
//  Created by PKW on 2024/01/25.
//

import UIKit

protocol HomeFilterHeaderViewDelegate: AnyObject {
    func didTabFilter1Button()
    func didTabFilter2Button()
    func didTabFilter3Button()
}

class HomeFilterHeaderView: UICollectionReusableView {
    
    weak var delegate: HomeFilterHeaderViewDelegate?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateFilterButtonTitle(viewModel: nil)
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
    
    func updateFilterButtonTitle(viewModel: HomeViewModel?) {
    
        let filter2Title = viewModel?.selectedCategoryIndex == nil ? "종류" : viewModel?.categoryList[viewModel?.selectedCategoryIndex ?? 0]
        let filter3Title = viewModel?.selectedDrinkingIndex == nil ? "주류 여부" : viewModel?.drinkingList[viewModel?.selectedDrinkingIndex ?? 0]
       
        filterButton1.setTitle(viewModel?.sortList[viewModel?.selectedSortIndex ?? 0], for: .normal)
        filterButton2.setTitle(filter2Title, for: .normal)
        filterButton3.setTitle(filter3Title, for: .normal)
        
//        if viewModel?.selectedCategoryIndex == 99999 {
//            filterButton2.setTitle("종류", for: .normal)
//        } else {
//            filterButton2.setTitle(viewModel?.categoryList[viewModel?.selectedCategoryIndex ?? 0], for: .normal)
//        }
//        
//        if viewModel?.selectedDrinkingIndex == 99999 {
//            filterButton3.setTitle("주류 여부", for: .normal)
//        } else {
//            filterButton3.setTitle(viewModel?.drinkingList[viewModel?.selectedDrinkingIndex ?? 0], for: .normal)
//        }
    }
}
