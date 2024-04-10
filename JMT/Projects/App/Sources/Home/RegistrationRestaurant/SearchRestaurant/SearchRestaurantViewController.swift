//
//  SearchRestaurantViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import SnapKit
import Then

class SearchRestaurantViewController: UIViewController {

    deinit {
        print("SearchRestaurantViewController Deinit")
    }
    
    // MARK: - Properties
    var viewModel: SearchRestaurantViewModel?
    
    @IBOutlet weak var searchRestaurantResultTableView: UITableView!
    @IBOutlet weak var searchRestaurantTextField: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "맛집 등록"
        setCustomNavigationBarBackButton(goToViewController: .popVC)
        
        setupBind()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - SetupBindings
    func setupBind() {
        viewModel?.onRestaurantsFetched = { [weak self] newIndexPaths in
            DispatchQueue.main.async {
                self?.searchRestaurantResultTableView.insertRows(at: newIndexPaths, with: .automatic)
            }
        }
    }
    
    // MARK: - SetupData
    func fetchSearchRestaurantsData() {
        
        viewModel?.locationManager.didUpdateLocations = { [weak self] in
        
            Task {
                do {
                    let keyword = self?.searchRestaurantTextField.text ?? ""
                    try await self?.viewModel?.fetchSearchRestaurantsData(keyword: keyword)
                    self?.updateTableView()
                } catch {
                    print(error)
                }
            }
        }
        
        viewModel?.locationManager.startUpdateLocation()
    }
    
    // MARK: - SetupUI
    func setupUI() {
        updateEmptyTableViewBackgroundView()
        
        searchRestaurantTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchRestaurantResultTableView.keyboardDismissMode = .onDrag
    }
    
    func updateEmptyTableViewBackgroundView() {
        let emptyView = UIView().then {
            $0.frame = CGRect(x: 0,
                              y: 0,
                              width: searchRestaurantResultTableView.bounds.width,
                              height: searchRestaurantResultTableView.bounds.height)
        }
                               
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 16
        }
        
        let emptyImageView = UIImageView().then {
            $0.image = JMTengAsset.resultEmptyImage.image
            $0.contentMode = .scaleAspectFit
        }
        
        let messageLabel = UILabel().then {
            $0.font = UIFont.settingFont(.pretendardBold, size: 16)
            $0.textColor = JMTengAsset.gray300.color
            $0.numberOfLines = 2
            $0.setAttributedText(str: "검색 결과가 없어요\n올바른 식당명인지 확인해주세요", lineHeightMultiple: 1.25, kern: -0.32, alignment: .center)
        }
        
        stackView.addArrangedSubview(emptyImageView)
        stackView.addArrangedSubview(messageLabel)
        emptyView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        searchRestaurantResultTableView.backgroundView = emptyView
    }
    
    func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchRestaurantResultTableView.reloadData()
        }
    }

    // MARK: - Actions
    @IBAction func didTabCancelButton(_ sender: Any) {
        searchRestaurantTextField.text = ""
        searchRestaurantTextField.resignFirstResponder()
        
        viewModel?.restaurantsInfo.removeAll()
        updateTableView()
    }
    
    // MARK: - Helper Methods
    
    // MARK: - CollectionView Delegate
    
    // MARK: - CollectionView DataSource
    
    // MARK: - Extention
}

// MARK: - TableView Delegate
extension SearchRestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.coordinator?.showSearchRestaurantMapViewController(info: viewModel?.restaurantsInfo[indexPath.row])
    }
}

// MARK: - TableView DataSource
extension SearchRestaurantViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.restaurantsInfo.isEmpty == true ? 0 : viewModel?.restaurantsInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as? RestaurantLocationCell else { return UITableViewCell() }
        cell.setupData(viewModel: viewModel?.restaurantsInfo[indexPath.row])
        return cell
    }
}

extension SearchRestaurantViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
        guard !viewModel!.isFetching, let maxIndexPath = indexPaths.max(), maxIndexPath.row >= viewModel!.restaurantsInfo.count - 1 else { return }
               
        Task {
            try await viewModel?.fetchSearchRestaurantsData(keyword: searchRestaurantTextField.text ?? "" )
        }
    }
}

// MARK: - TextField Delegate
extension SearchRestaurantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != "" else { return true }
        
        viewModel?.isSearch = true
        fetchSearchRestaurantsData()
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        viewModel?.currentPage = 1
        viewModel?.isSearch = false
        viewModel?.isEnd = false
        viewModel?.isFetching = false
        viewModel?.restaurantsInfo.removeAll()
        searchRestaurantResultTableView.reloadData()
    }
}




