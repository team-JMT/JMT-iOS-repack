//
//  RestaurantMoreMenuViewController.swift
//  JMTeng
//
//  Created by PKW on 3/27/24.
//

import UIKit

class RestaurantMoreMenuViewController: UIViewController {

    @IBOutlet weak var moreMenuTableView: UITableView!
    
    var viewModel: RestaurantDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moreMenuTableView.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 35, right: 0)
      
    }
}

extension RestaurantMoreMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? RestaurantMoreMenuCell else { return UITableViewCell() }
        cell.setupUI(index: indexPath.row)
        return cell
    }
    
}

extension RestaurantMoreMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            dismiss(animated: true) {
                self.viewModel?.coordinator?.showRegistrationRestaurantInfoViewController()
            }
        case 1:
            dismiss(animated: true) {
                self.viewModel?.coordinator?.showButtonPopupViewController()
            }
          
        case 2:
            print("3")
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66 + 12// 원하는 높이 값
    }
}
