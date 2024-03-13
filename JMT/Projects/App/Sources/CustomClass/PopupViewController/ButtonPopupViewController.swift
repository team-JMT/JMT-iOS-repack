//
//  ButtonPopupViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/23.
//

import UIKit

protocol ButtonPopupDelegate: AnyObject {
    func didTabDoneButton()
    func didTabCloseButton()
}

enum PopupType {
    case location
    case registrationRestaurant
    case searchRestaurant
    case none
}
    
class ButtonPopupViewController: UIViewController {

    weak var popupDelegate: ButtonPopupDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var popupType: PopupType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        popupDelegate?.didTabDoneButton()
        self.dismiss(animated: false)
    }
   
    @IBAction func didTabCancelButton(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func didTabCloseButton(_ sender: Any) {
        popupDelegate?.didTabCloseButton()
        self.dismiss(animated: false)
    }
    
    
    func setupUI() {
        containerView.layer.cornerRadius = 20

        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = JMTengAsset.main500.color.cgColor
        
        doneButton.layer.cornerRadius = 8
        
        setupTextLabel()
       
        switch popupType {
        case .location, .searchRestaurant:
            closeButton.isHidden = true
        case .registrationRestaurant:
            cancelButton.isHidden = true
            doneButton.isHidden = true
            closeButton.isHidden = false
        case .none:
            return
        }
        
    }
    
    func setupTextLabel() {
        switch popupType {
        case .location:
            titleLabel.text = "검색한 위치를 전체 삭제할까요?"
            subTitleLabel.text = "삭제한 기록은 다시 복구할 수 없어요"
            cancelButton.setTitle("그만두기", for: .normal)
            doneButton.setTitle("삭제하기", for: .normal)
        case .registrationRestaurant:
            titleLabel.text = "필수 항목을 입력해주세요"
            subTitleLabel.text = "(필수)항목을 입력해야\n맛집 등록을 할 수 있어요"
        case .searchRestaurant:
            titleLabel.text = "검색한 맛집을 전체 삭제할까요?"
            subTitleLabel.text = "삭제한 기록은 다시 복구할 수 없어요"
            cancelButton.setTitle("그만두기", for: .normal)
            doneButton.setTitle("삭제하기", for: .normal)
        case .none:
            return
        }
    }
}
