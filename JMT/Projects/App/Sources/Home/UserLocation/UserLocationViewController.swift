//
//  UserLocationViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/19.
//

import UIKit

class UserLocationViewController: UIViewController {

    var viewModel: UserLocationViewModel?
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressListTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var recentSearchView: UIView!
    
    var isFolded = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        
        viewModel?.onSuccess = {
            if self.viewModel?.isSearch == false {
                self.recentSearchView.isHidden = false
            } else {
                self.recentSearchView.isHidden = true
            }
            
            self.addressListTableView.reloadData()
        }
        
        viewModel?.getRecentLocations()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTabTextFieldCancelButton(_ sender: Any) {
        addressTextField.text = ""
        addressTextField.resignFirstResponder()
    }
    
    @IBAction func recentLocationDeleteAll(_ sender: Any) {
        viewModel?.coordinator?.showButtonPopupViewController()
    }
    
    

    func setupUI() {
        setCustomNavigationBarBackButton()
        self.navigationItem.title = "위치 변경"
        
        cancelButton.isHidden = true
        
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
}


extension UserLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? AddressTitleCell {
            
            if viewModel?.isSearch == false {
                let text = cell.addressNameLabel.text ?? ""
                addressTextField.text = text
                viewModel?.didChangeTextField(text: text)
            } else {
                // 위치 변경 코드
            }
        }
    }
}

extension UserLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.isSearch == false ? viewModel?.recentLocations.count ?? 0 : viewModel?.resultLocations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as? AddressTitleCell else { return UITableViewCell() }
        if viewModel?.isSearch == false {
            cell.addressNameLabel.text = viewModel?.recentLocations[indexPath.row]
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        } else {
            cell.addressNameLabel.text = viewModel?.resultLocations[indexPath.row]
            cell.deleteButton.isHidden = true
            return cell
        }
    }
}

extension UserLocationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.didChangeTextField(text: textField.text ?? "")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
        }
    }
}

extension UserLocationViewController: AddressTitleCellDelegate {
    func didTapDeleteButton(at indexPath: IndexPath) {
        viewModel?.deleteRecentLocation(index: indexPath)
    }
}

extension UserLocationViewController: ButtonPopupDelegate {
    func didTabDoneButton() {
        viewModel?.deleteAllRecentLocation()
    }
}
