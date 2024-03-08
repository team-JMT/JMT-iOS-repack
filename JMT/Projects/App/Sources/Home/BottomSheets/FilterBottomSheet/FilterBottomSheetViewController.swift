//
//  FilterBottomSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/26.
//

import UIKit
import FloatingPanel
import SnapKit

protocol FilterBottomSheetViewControllerDelegate: AnyObject {
    
}

class FilterBottomSheetViewController: UIViewController {
    
    weak var delegate: FilterBottomSheetViewControllerDelegate?
//    var fpc: FloatingPanelController?
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var filterTableView: UITableView!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var drinkingButton: UIButton!
    
    @IBOutlet weak var filterTypeContainerView: UIStackView!
    
    // 커스텀 이니셜라이저
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 여기에 필요한 초기화 코드를 추가합니다.
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel?.didUpdateSortTypeButton = {
            self.categoryButton.setTitleColor(self.viewModel?.sortType == .category ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            self.drinkingButton.setTitleColor(self.viewModel?.sortType == .drinking ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            self.filterTableView.reloadData()
        }
        
        viewModel?.didUpdateFilters = { bool in
            self.filterTableView.reloadData()
        }
    }
    
    func setupUI() {
        switch viewModel?.sortType {
        case .sort:
            filterTypeContainerView.isHidden = true
            
            filterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
            
        case .category, .drinking:
            filterTypeContainerView.isHidden = false
            
            self.categoryButton.setTitleColor(self.viewModel?.sortType == .category ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            self.drinkingButton.setTitleColor(self.viewModel?.sortType == .drinking ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            
            filterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12 + 110, right: 0)
            
        default:
            print("---")
        }
    }
    
    // 바텀시트 높이 문제로 일단 사용 X
    @IBAction func didTabCategoryButton(_ sender: Any) {
        //viewModel?.updateSortType(type: .category)
    }
    
    // 바텀시트 높이 문제로 일단 사용 X
    @IBAction func didTabDrinkingButton(_ sender: Any) {
        //viewModel?.updateSortType(type: .drinking)
    }
}

extension FilterBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateIndex(row: indexPath.row)
        
        if viewModel?.sortType == .sort {
            self.dismiss(animated: true)
        }
    }
}

extension FilterBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel?.sortType {
        case .sort:
            return 3
        case .category:
            return 8
        case .drinking:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterCell else { return UITableViewCell() }
        cell.setupCell(viewModel: viewModel, row: indexPath.row)
        return cell
    }
}

