//
//  RegistrationRestaurantMenuBottomSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import FloatingPanel

class RegistrationRestaurantCategoryBottomSheetViewController: UIViewController {
    
    deinit {
        print("RegistrationRestaurantCategoryBottomSheetViewController Deinit")
    }

    // MARK: - Properties
    weak var viewModel: RegistrationRestaurantInfoViewModel?
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet weak var selectedButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - SetupUI
    func setupUI() {
        selectedButton.layer.cornerRadius = 8
    }
    
    // MARK: - Actions
    @IBAction func didTabSelectedButton(_ sender: Any) {
        viewModel?.didUpdateCategory?()
        viewModel?.isSelectedCategory = true
        dismiss(animated: true) {
            self.selectedButton.removeFromSuperview()
        }
    }
    
    // MARK: - Helper Methods
    func updateTableVeiw() {
        DispatchQueue.main.async {
            self.categoryTableView.reloadData()
        }
    }
}

// MARK: - TableView Delegate
extension RegistrationRestaurantCategoryBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.updateSelectedCategory(row: indexPath.row)
        updateTableVeiw()
    }
}
// MARK: - TableView DataSource
extension RegistrationRestaurantCategoryBottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.categoryData.count ?? 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? RegistrationRestaurantCategoryCell else { return UITableViewCell() }
        let target = viewModel?.categoryData[indexPath.row]
        cell.setupData(category: target?.0 ?? "", isSelected: target?.1 ?? false, image: target?.2 ?? UIImage())
        return cell
    }
}

// MARK: - FloatingPanelController Delegate
extension RegistrationRestaurantCategoryBottomSheetViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
            print("1")
        case .half:
            print("2")
        case .tip:
            print("3")
        default:
            print("default")
        }
    }
}
