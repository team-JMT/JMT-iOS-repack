//
//  SearchRestaurantViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit

class SearchRestaurantViewController: UIViewController {

    var viewModel: SearchRestaurantViewModel?
    
    @IBOutlet weak var searchRestaurantResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "맛집 등록"
        setCustomNavigationBarBackButton(isSearchVC: false)
        
        viewModel?.didUpdateRestaurantsInfo = {
            self.searchRestaurantResultTableView.reloadData()
        }
        
        viewModel?.fetchRestaurantsInfo(keyword: "장강")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

//    @IBAction func didTabTest(_ sender: Any) {
//        viewModel?.coordinator?.showSearchRestaurantMapViewController()
//    }
}

extension SearchRestaurantViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.restaurantsInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? RestaurantLocationCell else { return UITableViewCell() }
        cell.setupData(viewModel: viewModel?.restaurantsInfo[indexPath.row])
        return cell
    }
}


extension SearchRestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.coordinator?.showSearchRestaurantMapViewController()
    }
}
