//
//  SearchViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        pageViewController?.searchPVDelegate = self
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.becomeFirstResponder()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchTextField.resignFirstResponder()
        self.navigationController?.isNavigationBarHidden = true
    }

    func setupUI() {
        
        setCustomNavigationBarBackButton(isSearchVC: true)
        
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
    
    @IBAction func didTabSegmentedController(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = viewModel?.currentSegIndex ?? 0 <= index ? .forward : .reverse

        if let pageVC = pageViewController {
            pageVC.setViewControllers([pageVC.vcArray[index]], direction: direction, animated: true)
            viewModel?.currentSegIndex = index
        }
    }
    
    @IBAction func didTabCancelButton(_ sender: Any) {
        viewModel?.recentResults.removeAll()
        
        searchTextField.text = ""
        searchTextField.becomeFirstResponder()
        recentContainerView.isHidden = false
        tagCollectionView.isHidden = false
        segmentedControllerContainerView.isHidden = true
        navigationController?.isNavigationBarHidden = false
        pageVCContainerView.isHidden = true
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.tagData.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
        cell.setupData(text: viewModel?.tagData[indexPath.row] ?? "")
        cell.delegate = self
        cell.deleteButton.tag = indexPath.row
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.text = viewModel?.recentResults[indexPath.row] ?? ""
        searchTextField.resignFirstResponder()
        recentContainerView.isHidden = true
        tagCollectionView.isHidden = true
        segmentedControllerContainerView.isHidden = false
        navigationController?.isNavigationBarHidden = true
        pageVCContainerView.isHidden = false
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (viewModel?.tagData[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width)! + 44, height: 29)
    }
}

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

extension SearchViewController: UITableViewDelegate {

}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recentContainerView.isHidden = true
        tagCollectionView.isHidden = true
        segmentedControllerContainerView.isHidden = false
        pageVCContainerView.isHidden = false
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.didChangeTextField(text: textField.text ?? "")
    }
}

extension SearchViewController: SearchPageViewControllerDelegate {
    func updateSegmentIndex(index: Int) {
        viewModel?.currentSegIndex = index
        segmentedController.selectedSegmentIndex = index
    }
}

extension SearchViewController: TagCollectionViewCellDelegate {
    func didTabDeleteButton(index: Int) {
        print(index)
    }
}
