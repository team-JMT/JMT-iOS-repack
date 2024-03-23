////
////  RegistrationRestaurantTypeBottomSheetViewController.swift
////  JMTeng
////
////  Created by PKW on 2024/02/04.
////
//
//import UIKit
//import FloatingPanel
//
//class RegistrationRestaurantTypeBottomSheetViewController: UIViewController {
//
//    // MARK: - Properties
//    var viewModel: RegistrationRestaurantInfoViewModel?
//    @IBOutlet weak var bottomContainerView: UIView!
//    @IBOutlet weak var typeTableView: UITableView!
//    @IBOutlet weak var selectedButton: UIButton!
//    
//    // MARK: - View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    
//    }
//    
//    // MARK: - SetupBindings
//    
//    // MARK: - SetupData
//    
//    // MARK: - SetupUI
//    func setupUI() {
//        selectedButton.layer.cornerRadius = 8
//    }
//    
//    // MARK: - Actions
//    @IBAction func didTabDoneButton(_ sender: Any) {
//        viewModel?.updateIsSelectedFilterType()
//        viewModel?.didCompletedFilterType?()
//        dismiss(animated: true)
//    }
//    
//    // MARK: - Helper Methods
//   
//}
//
//// MARK: - TableView Delegate
//extension RegistrationRestaurantTypeBottomSheetViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel?.updateFilterType(type: indexPath.row)
//        
//        DispatchQueue.main.async {
//            self.typeTableView.reloadData()
//        }
//    }
//}
//
//// MARK: - TableView DataSource
//extension RegistrationRestaurantTypeBottomSheetViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.categoryData.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath) as? RegistrationRestaurantTypeCell else { return UITableViewCell() }
//        
////        if indexPath.row < viewModel?.typeNames.count ?? 0 {
////            cell.typeNameLabel.text = viewModel?.typeNames[indexPath.row] ?? ""
////            cell.setupUI(isSelected: viewModel?.filterType == indexPath.row)
////        }
//        
//        return cell
//    }
//}
//
//// MARK: - FloatingPanelController DataSource
//extension RegistrationRestaurantTypeBottomSheetViewController: FloatingPanelControllerDelegate {
//    
//    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
//        switch fpc.state {
//        case .full:
//            print("1")
//        case .half:
//            print("2")
//        case .tip:
//            bottomContainerView.removeFromSuperview()
//            fpc.dismiss(animated: false)
//        default:
//            print("default")
//        }
//    }
//}
