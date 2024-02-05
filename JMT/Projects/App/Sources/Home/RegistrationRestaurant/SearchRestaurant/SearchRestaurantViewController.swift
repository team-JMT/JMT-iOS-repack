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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
//    @IBAction func didTabTest(_ sender: Any) {
//        viewModel?.coordinator?.showSearchRestaurantMapViewController()
//    }
}

extension SearchRestaurantViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}


extension SearchRestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.coordinator?.showSearchRestaurantMapViewController()
    }
}
