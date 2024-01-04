//
//  NicknameViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class NicknameViewController: UIViewController {

    var viewModel: NicknameViewModel?
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nicknameAvailabilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextButton.isEnabled = false
        nicknameTextField.text = ""
        nicknameAvailabilityLabel.text = ""
    }
        
    func bind() {
        viewModel?.onSuccess = { [weak self] state in
            switch state {
            case .updateNextButtonAndAvailabilityLabelText(let isEnabled, let text):
                self?.nextButton.isEnabled = isEnabled
                self?.nicknameAvailabilityLabel.text = text
            }
        }
    }
    
    @IBAction func didTabNextButton(_ sender: Any) {
        viewModel?.saveNickname(text: nicknameTextField.text ?? "")
    }
}

extension NicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.didChangeTextField(text: nicknameTextField.text ?? "")
    }
}
