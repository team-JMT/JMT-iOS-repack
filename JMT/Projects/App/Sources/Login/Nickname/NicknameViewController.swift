//
//  NicknameViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class NicknameViewController: UIViewController, KeyboardEvent {
    var transformView: UIView { return self.view }
    
    var viewModel: NicknameViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var nicknameTextField: UITextField!

    @IBOutlet weak var nicknameCheckStackView: UIStackView!
    @IBOutlet weak var nicknameCheckImageView: UIImageView!
    @IBOutlet weak var nicknameAvailabilityLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupKeyboardEvent { noti in
            guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
            
        } keyboardWillHide: { noti in
            self.containerView.transform = .identity
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        // 타이틀 레이블
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        titleLabel.attributedText = NSMutableAttributedString(string: "반가워요\n어떻게 불러드리면 될까요?", attributes: [NSAttributedString.Key.kern: -0.48, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 텍스트 필드
        nicknameTextField.layer.cornerRadius = 8
        
        // 왼쪽 패딩을 설정
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: nicknameTextField.frame.height))
        nicknameTextField.leftView = leftPaddingView
        nicknameTextField.leftViewMode = .always

        // 오른쪽 패딩을 설정
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: nicknameTextField.frame.height))
        nicknameTextField.rightView = rightPaddingView
        nicknameTextField.rightViewMode = .always
        
        nextButton.layer.cornerRadius = 8
        nextButton.isEnabled = false
    }
        
    
    func bind() {
        viewModel?.onSuccess = { [weak self] state in
            switch state {
            case .updateNextButtonAndAvailabilityLabelText(let isEnabled, let text):
                self?.nextButton.isEnabled = isEnabled
                self?.nextButton.backgroundColor = isEnabled ? JMTengAsset.main500.color : JMTengAsset.main200.color
                self?.nicknameAvailabilityLabel.text = text
                self?.nicknameCheckStackView.isHidden = (text == "") ? true : false
                self?.nicknameCheckImageView.image = isEnabled ? UIImage(named: "CheckMark") : UIImage(named: "Xmark")
                self?.nicknameAvailabilityLabel.textColor = isEnabled ? JMTengAsset.green500.color : JMTengAsset.red500.color
            }
        }
    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        
        if viewModel?.preventButtonTouch == true {
            return
        }
        
        if viewModel?.isSaveNickname == false {
            viewModel?.saveNickname(text: nicknameTextField.text ?? "")
        } else {
            viewModel?.coordinator?.showProfileViewController()
        }
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.didChangeTextField(text: nicknameTextField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
