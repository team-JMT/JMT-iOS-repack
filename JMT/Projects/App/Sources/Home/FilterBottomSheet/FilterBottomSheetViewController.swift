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
    
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fpc?.delegate = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let layout = FilterBottomSheetFloatingPanelLayout()
        layout.tbHeight = filterTableView.contentSize.height
        
        fpc?.layout = layout
    }
    
    func setupUI() {
        
        filterTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        
        fpc?.view.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        resetButton.layer.cornerRadius = 8
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = JMTengAsset.gray200.color.cgColor
        
        doneButton.layer.cornerRadius = 8
    }
}

extension FilterBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
}

extension FilterBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel?.filterType {
        case 0:
            return 3
        case 1:
            return 7
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterCell else { return UITableViewCell() }
        cell.setupCell(filter: viewModel?.filterType, index: indexPath.row)
        return cell
    }
    
}

extension FilterBottomSheetViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
           print("1")
        case .half:
            print("2")
        case .tip:
            bottomContainerView.removeFromSuperview()
            fpc.dismiss(animated: true)
        default:
            print("default")
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
