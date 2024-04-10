//
//  UserLocationViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import UIKit

class UserLocationViewController: UIViewController {
    
    // MARK: - Enum
    
    // MARK: - Properties
//    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressListTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recentSearchView: UIView!
    
    var viewModel: UserLocationViewModel?
    
    var isFolded = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        addressListTableView.keyboardDismissMode = .onDrag
        
        viewModel?.onSuccess = {
            self.addressListTableView.reloadData()
            self.addressListTableView.isUserInteractionEnabled = true
        }
        
        viewModel?.fetchRecentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "위치 변경"
        
        setCustomNavigationBarBackButton(goToViewController: .popVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - SetupBindings
    
    // MARK: - FetchData
    
    // MARK: - SetupData
    
    // MARK: - SetupUI
    func setupUI() {
        cancelButton.isHidden = true
        
//        setupNavigationBar()
        setupTextField()
    }
    
//    func setupNavigationBar() {
//        customNavigationBar.setupTitle(title: "위치 변경")
//    }
    
    func setupTextField() {
        // 텍스트 필드
        addressTextField.layer.cornerRadius = 8
        
        // 오른쪽 패딩을 설정
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: addressTextField.frame.height))
        addressTextField.rightView = rightPaddingView
        addressTextField.rightViewMode = .always
        
        let image = UIImage(named: "TextFieldSearch")!
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: addressTextField.frame.height))
        leftImageView.image = image
        leftImageView.contentMode = .scaleAspectFit // 이미지를 중앙에 배치
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: addressTextField.frame.height))
        leftView.addSubview(leftImageView)
        leftImageView.center = CGPoint(x: leftView.frame.width / 2, y: leftView.frame.height / 2)
        addressTextField.leftView = leftView
        addressTextField.leftViewMode = .always // 항상 보이도록 설정
    }
    
    
    // MARK: - Actions
    @IBAction func didTabTextFieldCancelButton(_ sender: Any) {
        addressTextField.text = ""
        addressTextField.resignFirstResponder()
        finishSearch()
    }
    
    @IBAction func recentLocationDeleteAll(_ sender: Any) {
        viewModel?.coordinator?.showButtonPopupViewController()
    }
    
    // MARK: - Helper Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func finishSearch() {
        viewModel?.isSearch = false
        viewModel?.isEnd = false
        viewModel?.isFetching = false
        cancelButton.isHidden = true
        recentSearchView.isHidden = false
        addressListTableView.reloadData()
    }
}

// MARK: - TableView Delegate
extension UserLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        addressListTableView.isUserInteractionEnabled = false
        
        if viewModel?.isSearch == false {
            addressTextField.becomeFirstResponder()
            addressTextField.text = viewModel?.recentLocations[indexPath.row] ?? ""
            viewModel?.handleTextChange(keyword: addressTextField.text ?? "")
            
        } else {
            let location = viewModel?.resultLocations[indexPath.row]
            viewModel?.coordinator?.showConvertUserLocationViewController(with: location)
            addressListTableView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - TableView DataSource
extension UserLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.isSearch == true ? viewModel?.resultLocations.count ?? 0 : viewModel?.recentLocations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as? AddressTitleCell else { return UITableViewCell() }
        if viewModel?.isSearch == false {
            cell.addressNameLabel.text = viewModel?.recentLocations[indexPath.row] ?? ""
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        } else {
            cell.addressNameLabel.text = viewModel?.resultLocations[indexPath.row].placeName ?? ""
            cell.deleteButton.isHidden = true
            return cell
        }
    }
}

extension UserLocationViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard viewModel?.isSearch == true else { return }
        
        if indexPaths.contains(where: isLoadingCell) {
            viewModel?.fetchSearchLocation(keyword: addressTextField.text ?? "")
        }
    }
    
    // 지정된 인덱스 패스가 로딩 셀인지 확인하는 메소드
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (viewModel?.resultLocations.count ?? 0) - 1
    }
}

// MARK: - CollectionView Delegate

// MARK: - CollectionView DataSource

// MARK: - Extention
extension UserLocationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel?.isSearch = true
        cancelButton.isHidden = false
        recentSearchView.isHidden = true
        addressListTableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            finishSearch()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel?.resetSearchState()
        viewModel?.handleTextChange(keyword: textField.text ?? "")
        return true
    }
}

extension UserLocationViewController: AddressTitleCellDelegate {
    func didTapDeleteButton(at indexPath: IndexPath) {
        viewModel?.deleteRecentLocation(indexPath.row)
    }
}

extension UserLocationViewController: ButtonPopupDelegate {
    func didTabDoneButton() {
        viewModel?.deleteAllRecentLocation()
    }
    
    func didTabCloseButton() { }
    func didTabCancelButton() { }
}







