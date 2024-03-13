//
//  SearchViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: SearchViewModel?

    @IBOutlet weak var searchTextField: SearchTextField!
    
    @IBOutlet weak var recentContainerView: UIView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    @IBOutlet weak var segmentedControllerContainerView: UIView!
    @IBOutlet weak var segmentedController: CustomSegmentedControl!
    
    @IBOutlet weak var pageVCContainerView: UIView!
    
    var pageViewController: SearchPageViewController?
    
    var currentIndex: Int = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBind()
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        viewModel?.fetchRecentSearchRestaurants()
        print(viewModel?.recentSearchRestaurants)
        
        pageViewController?.searchPVDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setupBarAppearance(alpha: 1)
        
//        if let coordinator = viewModel?.coordinator?.parentCoordinator as? DefaultTabBarCoordinator {
//            if coordinator.tabBarController.isHomeSearchButton {
//                self.navigationController?.setNavigationBarHidden(false, animated: false)
//            } else {
//                self.navigationController?.setNavigationBarHidden(true, animated: false)
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        if let coordinator = viewModel?.coordinator?.parentCoordinator as? DefaultTabBarCoordinator {
//            coordinator.tabBarController.isHomeSearchButton = false
//        }
    }

    
    // MARK: - SetupBindings
    func setupBind() {
        viewModel?.onSuccess = {
            if self.viewModel?.recentResults.isEmpty == true {
                self.recentContainerView.isHidden = false
                self.tagCollectionView.isHidden = false
            } else {
                self.recentContainerView.isHidden = true
                self.tagCollectionView.isHidden = true
            }
            
            self.searchResultTableView.reloadData()
        }
    }
    
    // MARK: - FetchData
    
    // MARK: - SetupData
    
    // MARK: - SetupUI
    func setupUI() {
        
        self.navigationItem.title = "검색"
        tagCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        segmentedControllerContainerView.isHidden = true
        pageVCContainerView.isHidden = true
        
        if let pageVC = pageViewController {
            self.addChild(pageVC)
            pageVCContainerView.addSubview(pageVC.view)
            pageVC.didMove(toParent: self)
            
            pageVC.view.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
        
        if viewModel?.tagData.isEmpty == true {
            tagCollectionView.isHidden = true
        } else {
            tagCollectionView.isHidden = false
        }
    }
    
    // MARK: - Actions
    @IBAction func didTabSegmentedController(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = viewModel?.currentSegIndex ?? 0 <= index ? .forward : .reverse

        if let pageVC = pageViewController {
            pageVC.setViewControllers([pageVC.vcArray[index]], direction: direction, animated: true)
            viewModel?.currentSegIndex = index
        }
    }
    
    @IBAction func didTabCancelButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.searchTextField.text = ""
            self.recentContainerView.isHidden = false
            self.tagCollectionView.isHidden = false
            self.segmentedControllerContainerView.isHidden = true
            self.pageVCContainerView.isHidden = true
        }
        
//        viewModel?.recentResults.removeAll()
//        
//        searchTextField.text = ""
//        searchTextField.becomeFirstResponder()
//        recentContainerView.isHidden = false
//        tagCollectionView.isHidden = false
//        segmentedControllerContainerView.isHidden = true
//        pageVCContainerView.isHidden = true
    }
    
    @IBAction func didTabDeleteRecentKeywordButton(_ sender: Any) {
        viewModel?.coordinator?.showButtonPopupViewController()
    }
    
    
    // MARK: - Helper Methods
    

    

    
    // MARK: - Extention
    

    
    
    
    
    
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate { }

// MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.recentResults.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        cell.searchResultLabel.text = viewModel?.recentResults[indexPath.row]
        return cell
    }
}

// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.searchTextField.text = self.viewModel?.recentSearchRestaurants[indexPath.item] ?? ""
            self.searchTextField.resignFirstResponder()
            
            self.recentContainerView.isHidden = true
            self.tagCollectionView.isHidden = true
            
            self.segmentedControllerContainerView.isHidden = false
            self.pageVCContainerView.isHidden = false
        }
    }
}

// MARK: - CollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.recentSearchRestaurants.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        cell.setupData(text: viewModel?.recentSearchRestaurants[indexPath.item] ?? "")
        cell.delegate = self
        cell.deleteButton.tag = indexPath.item
        return cell
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (viewModel?.recentSearchRestaurants[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width)! + 46, height: 29)
    }
}

// MARK: - UITextField Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.saveRecentSearchRestaurants(keyword: textField.text ?? "")
        viewModel?.fetchRecentSearchRestaurants()
        
        DispatchQueue.main.async {
            self.tagCollectionView.reloadData()
            self.recentContainerView.isHidden = true
            self.tagCollectionView.isHidden = true
            self.segmentedControllerContainerView.isHidden = false
            self.pageVCContainerView.isHidden = false
        }
        
        
        return true
    }
    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        viewModel?.didChangeTextField(text: textField.text ?? "")
//    }
}

// MARK: - SearchPageViewController Delegate
extension SearchViewController: SearchPageViewControllerDelegate {
    func updateSegmentIndex(index: Int) {
        viewModel?.currentSegIndex = index
        segmentedController.selectedSegmentIndex = index
    }
}

// MARK: - TagCollectionViewCell Delegate
extension SearchViewController: TagCollectionViewCellDelegate {
    func didTabDeleteButton(index: Int) {
        
        viewModel?.deleteRecentSearchRestaurants(index)
       
        tagCollectionView.performBatchUpdates {
            tagCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        } completion: { _ in
            self.tagCollectionView.reloadData()
        }
    }
}

extension SearchViewController: ButtonPopupDelegate {
    func didTabDoneButton() {
        viewModel?.deleteAllRecentSearchRestaurants()
        
        DispatchQueue.main.async {
            self.tagCollectionView.reloadData()
        }
    }
    
    func didTabCloseButton() { }
}
