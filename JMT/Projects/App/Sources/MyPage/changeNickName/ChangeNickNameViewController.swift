//
//  ChangeNickNameViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/29/24.
//

import UIKit
import Alamofire

class ChangeNickNameVC: UIViewController {
    
    var viewModel: MyPageChangeNickNameViewModel?
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var updateTF: UITextField!
    
    @IBOutlet weak var vaildation: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var BoolImage: UIImageView!
    @IBOutlet weak var btnView: UIView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setCustomNavigationBarBackButton(isSearchVC: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let border = CALayer()
        let width = CGFloat(0.5)
        
        
        border.borderColor = UIColor(named: "gray400")?.cgColor
        border.frame = CGRect(x: 0, y: updateTF.frame.size.height - width, width: updateTF.frame.size.width, height: updateTF.frame.size.height)
        
        border.borderWidth = width
        
        updateTF.layer.addSublayer(border)
        updateTF.layer.masksToBounds = true
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        
        //키보드 올렷다 내리기
        self.bottomConstrain = NSLayoutConstraint(item: self.buttonView, attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.bottomConstrain?.isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        updateTF.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        updateTF.delegate = self
        
        userName.textColor =  UIColor(red: 0.489, green: 0.565, blue: 0.611, alpha: 1)
        
        
        buttonView.layer.cornerRadius = 12
        nextBtn.layer.cornerRadius = 12
        
        updateTF.setCustomClearButton()
        
        navigationItems()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - 네비게이션
    private func navigationItems() {
        // SFSymbol을 사용해서 왼쪽 '뒤로가기' 버튼을 설정합니다.
        let leftImage = UIImage(named: "leftArrow")
        let leftButton = UIButton(type: .custom)
        
        // 버튼의 크기와 이미지의 contentMode를 설정
        leftButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        leftButton.contentMode = .scaleAspectFit
        
        leftButton.setImage(leftImage, for: .normal)
        leftButton.tintColor = UIColor(named: "gray700")
        leftButton.addTarget(self, action: #selector(yourSelector1), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    @objc func yourSelector1() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - 서버로 닉네임 전송
//    func sendNicknameToServer(nickname: String, token: String, completion: @escaping (Bool) -> Void) {
//        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
//            print("애플Access Token: \(accessToken)")
//            
//            let url = URL(string: "https://api.jmt-matzip.dev/api/v1/user/nickname")!
//            let headers: HTTPHeaders = [
//                "accept": "*/*",
//                "Authorization": "Bearer \(accessToken)",
//                "Content-Type": "application/json"
//            ]
//            let parameters: [String: Any] = [
//                "nickname": nickname
//            ]
//            
//            
//            DispatchQueue.main.async {
//                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//                    .validate()
//                    .responseDecodable(of: NicknameRegister.self) { response in
//                        switch response.result {
//                        case .success(let nicknameData):
//                            print("Nickname data: \(nicknameData)")
//                            UserDefaults.standard.set(true, forKey: "ShouldShowToastPopup")
//                            UserDefaults.standard.set(nickname, forKey: "nickname") // Update the nickname in UserDefaults
//                            
//                            NotificationCenter.default.post(name: Notification.Name("NicknameUpdateSuccess"), object: nil)
//                            completion(true)
//                        case .failure(let error):
//                            print("Error sending nickname to server: \(error)")
//                            completion(false)
//                        }
//                    }
//            }
//        }
//    }
    
    
    
    func sendNicknameToServer(nickname: String, token: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://api.jmt-matzip.dev/api/v1/user/nickname")!
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["nickname": nickname]

        // Alamofire를 사용하여 서버에 닉네임 전송
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: NicknameRegister.self) { response in
                switch response.result {
                case .success:
                    // 서버로부터 성공 응답을 받았을 때
                    print("Nickname update success!")
                    completion(true)
                case .failure(let error):
                    // 요청 실패
                    print("Error sending nickname to server: \(error)")
                    completion(false)
                }
            }
    }

    
    func checkNicknameDuplication(nickname: String, completion: @escaping (Bool) -> Void) {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            let escapedNickname = nickname.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            let url = URL(string: "https://api.jmt-matzip.dev/api/v1/user/\(escapedNickname)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("*/*", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(false) // 중복됨
                    } else if httpResponse.statusCode == 409 {
                        completion(true) // 사용 가능함
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    
    @IBAction func updateNickname(_ sender: Any) {
        
        guard let newNickname = updateTF.text, !newNickname.isEmpty else {
                print("No new nickname provided.")
                return
            }
            
            let keychainAccess = DefaultKeychainAccessible()
            if let accessToken = keychainAccess.getToken("accessToken") {
                // 서버에 닉네임 전송
                sendNicknameToServer(nickname: newNickname, token: accessToken) { [weak self] success in
                    if success {
                        // 닉네임 업데이트 성공 처리
                        self?.handleNicknameUpdateSuccess(nickname: newNickname)
                    } else {
                        // 닉네임 업데이트 실패 처리
                        self?.handleNicknameUpdateFailure()
                    }
                }
            } else {
                print("Access Token is not available")
            }
    }
    
    
    func showToastWithCustomLayout(message: String, duration: TimeInterval = 3.0) {
        let toastContainer = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 56))
        toastContainer.backgroundColor = .white // 배경색 설정
        toastContainer.layer.cornerRadius = 8
        toastContainer.layer.shadowColor = UIColor(red: 0.086, green: 0.102, blue: 0.114, alpha: 0.08).cgColor
        toastContainer.layer.shadowOpacity = 1
        toastContainer.layer.shadowRadius = 16
        toastContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        toastContainer.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-100) // 화면 하단 중앙에 위치
        self.view.addSubview(toastContainer)

        let checkImageView = UIImageView(image: UIImage(named: "CheckMark")) // 이미지 이름 확인 필요
        checkImageView.contentMode = .scaleAspectFit

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont(name: "Pretendard-Bold", size: 14.0) // 글꼴 이름 확인 필요
        messageLabel.textColor = .black
        messageLabel.textAlignment = .left

        let stackView = UIStackView(arrangedSubviews: [checkImageView, messageLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.addSubview(stackView)

        // 스택뷰의 제약 조건 설정
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -16),
            checkImageView.widthAnchor.constraint(equalToConstant: 24), // 이미지 뷰의 너비 고정
            checkImageView.heightAnchor.constraint(equalToConstant: 24) // 이미지 뷰의 높이 고정
        ])

        // 애니메이션을 사용하여 토스트 메시지 표시 후 자동으로 사라지게 함
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastContainer.alpha = 0.0
        }, completion: { _ in
            toastContainer.removeFromSuperview()
        })
    }

    
    func handleNicknameUpdateSuccess(nickname: String) {
        print("Nickname update success!")
        updateNicknameInProfileViewController(nickname: nickname)
        NotificationCenter.default.post(name: NSNotification.Name("NicknameUpdateSuccess"), object: nil)
        DispatchQueue.main.async {
            self.showToastWithCustomLayout(message: "닉네임이 성공적으로 변경되었습니다.")
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func showNicknameUpdateSuccessToast() {
        showToastWithCustomLayout(message: "닉네임이 성공적으로 변경되었습니다.", duration: 2.0)
    }

    
    
    
    func handleNicknameUpdateFailure() {
        print("Nickname update failed!")
    }
    
    
    
    private func updateNicknameInProfileViewController(nickname: String) {
        if let profileVC = navigationController?.viewControllers.first(where: { $0 is DetailMyPageVC }) as? DetailMyPageVC {
            profileVC.userNickname.text = nickname
        }
    }
}

extension ChangeNickNameVC: UITextFieldDelegate {
    
    
    //MARK: 유효성 검사
    func validateInput(_ input: String) -> Bool {
        if input.count > 10 {
            return false
        }
        let specialCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "가-힣"))
        if input.rangeOfCharacter(from: specialCharacterSet.inverted) != nil {
            return false
        }
        return true
    }
    
    // 엔터 누르면 일단 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - 이메일텍스트필드, 비밀번호 텍스트필드 두가지 다 채워져 있을때 색 변경
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        print("textFieldEditingChanged called")
        
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard let nickname = updateTF.text, !nickname.isEmpty else {
            nextBtn.backgroundColor = UIColor(named: "main200")
            nextBtn.isEnabled = false
            vaildation.isHidden = true // 입력이 없으면 Validation 숨기기
            BoolImage.isHidden = true // 입력이 없으면 vaildImage 숨기기
            
            return
        }
        
        
        checkNicknameDuplication(nickname: nickname) { isAvailable in
            DispatchQueue.main.async {
                if isAvailable {
                    self.vaildation.text = "중복된 닉네임입니다."
                    self.vaildation.textColor = UIColor(red: 1, green: 0.14, blue: 0.35, alpha: 1)
                    self.nextBtn.backgroundColor = UIColor(named: "main200")
                    self.nextBtn.isEnabled = false
                    self.BoolImage.image = UIImage(named: "Xmark")
                } else {
                    // 입력값이 유효한지 검사
                    let isValid = self.validateInput(nickname)
                    
                    // Validation 레이블에 메시지 출력
                    self.vaildation.text = isValid ? "사용 가능한 닉네임입니다." : "사용 불가능한 닉네임입니다."
                    self.vaildation.textColor = isValid ? UIColor(red: 0.24, green: 0.77, blue: 0.29, alpha: 1) : UIColor(red: 1, green: 0.14, blue: 0.35, alpha: 1)
                    
                    // nextButton 배경색상과 활성화 여부 업데이트
                    self.nextBtn.backgroundColor = isValid ? UIColor(named: "main500") : UIColor(named: "main200")
                    self.nextBtn.isEnabled = isValid
                    
                    // vaildImage에 이미지 설정
                    self.BoolImage.image = isValid ? UIImage(named: "CheckMark") : UIImage(named: "Xmark")
                    
                    
                    if let image = UIImage(named: "Xmark") {
                        print("Image loaded successfully")
                    } else {
                        print("Failed to load the image")
                    }
                    
                }
            }
        }
        
        
        // 입력값이 유효한지 검사
        let isValid = validateInput(nickname)
        
        // Validation 레이블에 메시지 출력
        vaildation.text = isValid ? "사용 가능한 닉네임입니다." : "사용 불가능한 닉네임입니다."
        vaildation.textColor = isValid ? UIColor(red: 0.24, green: 0.77, blue: 0.29, alpha: 1) : UIColor(red: 1, green: 0.14, blue: 0.35, alpha: 1)
        vaildation.isHidden = false // 입력이 있으면 Validation 보이기
        
        // nextButton 배경색상과 활성화 여부 업데이트
        nextBtn.backgroundColor = isValid ? UIColor(named: "main500") : UIColor(named: "main200")
        nextBtn.isEnabled = isValid
        
        // vaildImage에 이미지 설정
        BoolImage.image = isValid ? UIImage(named: "CheckMark") : UIImage(named: "Xmark")
        BoolImage.isHidden = false
    }
    
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat = keyboardSize.height
            
            // bottomConstrain의 constant 값을 -keyboardHeight로 설정하여 buttonView가 키보드 상단에 위치하게 합니다.
            self.bottomConstrain.constant = -keyboardHeight
            
            // 애니메이션으로 뷰의 변화를 표현합니다.
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 bottomConstrain의 constant 값을 0으로 설정하여 원래 위치로 돌아가게 합니다.
        self.bottomConstrain.constant = 0
        
        // 애니메이션으로 뷰의 변화를 표현합니다.
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
}

extension UITextField {
    
    func setCustomClearButton() {
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        if let xIcon = UIImage(systemName: "xmark")?.withConfiguration(configuration) {
            setClearButton(with: xIcon, mode: .whileEditing)
        }
    }
    
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        clearButton.contentMode = .center // 이미지를 중앙에 위치시킵니다.
        clearButton.tintColor = .lightGray
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
        self.rightView = clearButton
        self.rightViewMode = mode
    }
    
    
    @objc
    private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
}

