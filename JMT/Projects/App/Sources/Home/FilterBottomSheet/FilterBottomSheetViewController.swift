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
    var fpc: FloatingPanelController?
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var filterTableView: UITableView!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var drinkingButton: UIButton!
    
    @IBOutlet weak var filterTypeContainerView: UIStackView!
   
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
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
        
        fpc?.delegate = self
        setupUI()
        
        viewModel?.didUpdateSortTypeButton = {
            self.categoryButton.setTitleColor(self.viewModel?.sortType == .category ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            self.drinkingButton.setTitleColor(self.viewModel?.sortType == .drinking ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            self.filterTableView.reloadData()
        }
        
        viewModel?.didUpdateFilters = { bool in
            if bool {
                self.bottomContainerView.removeFromSuperview()
                self.dismiss(animated: true)
            }
            self.filterTableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = FilterBottomSheetFloatingPanelLayout()
        fpc?.layout = layout
    }
    
    func setupUI() {
        switch viewModel?.sortType {
        case .sort:
            filterTypeContainerView.isHidden = true
            
            filterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
            
        case .category, .drinking:
            filterTypeContainerView.isHidden = false
            
            fpc?.view.addSubview(bottomContainerView)
            bottomContainerView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            self.categoryButton.setTitleColor(self.viewModel?.sortType == .category ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            self.drinkingButton.setTitleColor(self.viewModel?.sortType == .drinking ? JMTengAsset.gray900.color : JMTengAsset.gray400.color, for: .normal)
            
            filterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12 + 110, right: 0)
            
        default:
            print("---")
        }
       
        resetButton.layer.cornerRadius = 8
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = JMTengAsset.gray200.color.cgColor
        
        doneButton.layer.cornerRadius = 8
    }
    
    @IBAction func didTabCategoryButton(_ sender: Any) {
        viewModel?.updateSortType(type: .category)
    }
    
    @IBAction func didTabDrinkingButton(_ sender: Any) {
        viewModel?.updateSortType(type: .drinking)
    }
    
    @IBAction func didTabResetButton(_ sender: Any) {
        viewModel?.resetUpdateIndex()
    }
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        viewModel?.saveUpdateIndex()
        viewModel?.fetchRestaurantsData()
        bottomContainerView.removeFromSuperview()
        dismiss(animated: true)
    }
}

extension FilterBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateIndex(row: indexPath.row)
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

extension FilterBottomSheetViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .tip:
            viewModel?.cancelUpdateIndex()
            bottomContainerView.removeFromSuperview()
            fpc.dismiss(animated: true)
        default:
            return
        }
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
//        if fpc.isAttracting == false || fpc.isAttracting == true {
//            if fpc.surfaceLocation.y < 65 + self.view.safeAreaInsets.top {
//                fpc.surfaceLocation.y = 65 + self.view.safeAreaInsets.top
//            }
//        }
    }
}
