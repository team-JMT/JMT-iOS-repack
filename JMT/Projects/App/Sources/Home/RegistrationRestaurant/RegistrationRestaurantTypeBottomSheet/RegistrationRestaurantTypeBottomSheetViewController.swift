//
//  RegistrationRestaurantTypeBottomSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import FloatingPanel

class RegistrationRestaurantTypeBottomSheetViewController: UIViewController {

    var viewModel: RegistrationRestaurantInfoViewModel?
   
    var fpc: FloatingPanelController?
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var typeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fpc?.delegate = self
        fpc?.contentMode = .fitToBounds

        let layout = RegistrationRestaurantTypeBottomSheetFloatingPanelLayout()
        fpc?.layout = layout
        
        fpc?.view.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        viewModel?.updateIsSelectedFilterType()
        viewModel?.didCompletedFilterType?()
        dismiss(animated: true)
    }
}

extension RegistrationRestaurantTypeBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.typeNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath) as? RegistrationRestaurantTypeCell else { return UITableViewCell() }
        
        if indexPath.row < viewModel?.typeNames.count ?? 0 {
            cell.typeNameLabel.text = viewModel?.typeNames[indexPath.row] ?? ""
            cell.setupUI(isSelected: viewModel?.filterType == indexPath.row)
        }
        
        return cell
    }
}

extension RegistrationRestaurantTypeBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateFilterType(type: indexPath.row)
        
        DispatchQueue.main.async {
            self.typeTableView.reloadData()
        }
    }
}

extension RegistrationRestaurantTypeBottomSheetViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
            print("1")
        case .half:
            print("2")
        case .tip:
            bottomContainerView.removeFromSuperview()
            fpc.dismiss(animated: false)
        default:
            print("default")
        }
    }
}
