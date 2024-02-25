//
//  MyPageTestViewController.swift
//  App
//
//  Created by 이지훈 on 1/18/24.
//

import UIKit
import Alamofire


class DetailMyPageVC : UIViewController {
    
    weak var coordinator: DetailMyPageCoordinator?
    var viewModel: DetailMyPageViewModel?
    
    
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mainTable: UITableView!
    
    let cellName = "ProfileCell"
    let cellLable: Array<String> = ["계정관리", "서비스 이용동의", "개인정보 처리방식"," "]
    
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        //닉네임 변경 플래그 + 노티
    //        NotificationCenter.default.addObserver(self, selector: #selector(showToastPopup), name: Notification.Name("NicknameUpdateSuccess"), object: nil)
    
    //        // UserDefaults의 값 확인
    //        let shouldShowToastPopup = UserDefaults.standard.bool(forKey: "ShouldShowToastPopup")
    //        if shouldShowToastPopup {
    //            showToastPopup()
    //            UserDefaults.standard.set(false, forKey: "ShouldShowToastPopup") // 토스트 팝업 표시 후에는 이 값을 false로 리셋
    //        }
    //
    //
    //        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
    //            userNickname.text = nickname
    //        }
    //
    //        fetchProfile()
    //
    //
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //
    //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("NicknameUpdateSuccess"), object: nil)
    //    }
    //
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel?.coordinator == nil {
            print("Coordinator in DetailMyPageVC's viewModel is nil")
        } else {
            print("Coordinator in DetailMyPageVC's viewModel is not nil")
        }
    
        //    profileImageView.layer.cornerRadius = profileImageView.layer.frame.size.width / 2
        profileImage.layer.cornerRadius = profileImage.layer.frame.size.width / 2
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        navigationItems()
        
      //  fetchProfile()
        
        userEmail.lineBreakMode = .byTruncatingMiddle
        
        mainTable.separatorStyle = .singleLine
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(showToastPopup), name: Notification.Name("NicknameUpdateSuccess"), object: nil)
        //
        //        UserDefaults.standard.set(false, forKey: "ShouldShowToastPopup") // 처음 로드될 때 토스트 팝업이 나타나지 않도록 플래그를 설정
        
    }
    
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
    
    
    //이하 토스트 팝업
    func handleNicknameUpdateSuccess(nickname: String) {
        print("Nickname update success!")
        UserDefaults.standard.set(nickname, forKey: "nickname") // Update the nickname in UserDefaults
        
        
        self.userNickname.text = nickname
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//    
//    @objc func showToastPopup() {
//        print("showToastPopup Called!")
//        DispatchQueue.main.async {
//            self.showToastMessage("닉네임이 성공적으로 업데이트되었습니다.", imageName: "yesMark")
//        }
//    }
//    
    
    //    @objc private func handleNicknameUpdate(_ notification: Notification) {
    //
    //        if let userInfo = notification.userInfo,
    //           let isSuccess = userInfo["isSuccess"] as? Bool,
    //           let nickname = userInfo["nickname"] as? String {
    //            if isSuccess {
    //                showToastMessage("프로필 사진 변경이 완료되었어요.", imageName: "yesMark")
    //            } else {
    //                showToastMessage("프로필 사진을 변경하지 못했어요.", imageName: "noMark")
    //            }
    //        }
    //    }
    //
    //    private func showToastMessage(_ message: String, imageName: String) {
    //        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 56))
    //        toastView.backgroundColor = .white
    //        toastView.layer.cornerRadius = 12
    //        configureShadow(for: toastView) // 그림자 추가
    //
    //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
    //        imageView.image = UIImage(named: imageName)
    //        imageView.contentMode = .scaleAspectFit
    //        toastView.addSubview(imageView)
    //
    //        let label = UILabel()
    //        label.text = message
    //        label.font = UIFont(name: "Pretendard-Medium", size: 16)
    //        label.textColor = .black
    //        label.numberOfLines = 0
    //        label.textAlignment = .center // 텍스트를 중앙에 배치
    //        toastView.addSubview(label)
    //
    //        // ImageView와 Label을 중앙에 배치
    //        let spacing: CGFloat = 8 // ImageView와 Label 사이의 간격
    //        let totalWidth = toastView.frame.width
    //        let contentWidth = imageView.frame.width + spacing + label.intrinsicContentSize.width
    //        imageView.center = CGPoint(x: (totalWidth - contentWidth) / 2 + imageView.frame.width / 2, y: toastView.frame.height / 2)
    //        label.frame = CGRect(x: imageView.frame.maxX + spacing, y: 0, width: label.intrinsicContentSize.width, height: toastView.frame.height)
    //
    //        self.view.showToast(toastView, duration: 3.0, position: .bottom)
    //    }
    //
    //    //뒤에 그림자
    //    private func configureShadow(for view: UIView) {
    //        view.layer.cornerRadius = 8
    //        view.layer.masksToBounds = false
    //        view.layer.shadowColor = UIColor(red: 0.086, green: 0.102, blue: 0.114, alpha: 0.08).cgColor
    //        view.layer.shadowOffset = CGSize(width: 0, height: 4)
    //        view.layer.shadowRadius = 4
    //        view.layer.shadowOpacity = 1
    //    }
    //
    //
    // 구글에 이미지 전송
    func sendProfileImageToGoogleServer(with imageData: Data) {
        let url = URL(string: "https://api.jmt-matzip.dev/api/v1/user/profileImg")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "CustomAccessToken") ?? "")",
            "Accept": "*/*"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "profileImg", fileName: "profile.png", mimeType: "image/png")
        }, to: url, method: .post, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Image successfully uploaded to Google server: \(value)")
            case .failure(let error):
                print("Failed to upload image to Google server: \(error.localizedDescription)")
            }
        }
    }
    
    
    // 애플에 이미지 전송
    func sendProfileImageToAppleServer(with imageData: Data) {
        let url = URL(string: "https://api.jmt-matzip.dev/api/v1/user/profileImg")!
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
            "Accept": "*/*"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "profileImg", fileName: "profile.png", mimeType: "image/png")
        }, to: url, method: .post, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Image successfully uploaded to Apple server: \(value)")
            case .failure(let error):
                print("Failed to upload image to Apple server: \(error.localizedDescription)")
            }
        }
    }
    
    
    //이미지 전송할곳 분기
    func sendProfileImageToServer(with imageData: Data) {
        guard let compressedImageData = compressImage(UIImage(data: imageData)!, toSizeInMB: 1) else {
            print("Failed to compress image data.")
            return
        }
        
        if UserDefaults.standard.string(forKey: "loginMethod") == "apple" {
            sendProfileImageToAppleServer(with: compressedImageData)
        } else if UserDefaults.standard.string(forKey: "loginMethod") == "google" {
            sendProfileImageToGoogleServer(with: compressedImageData)
        }
    }
    
    //
    //    func showImageView(_ sender: UIButton) {
    //        let imagePicker = UIImagePickerController()
    //        imagePicker.delegate = self
    //        imagePicker.sourceType = .photoLibrary
    //        present(imagePicker, animated: true, completion: nil)
    //    }
    //
    //이미지 압축
    func compressImage(_ image: UIImage, toSizeInMB maxSizeInMB: Double) -> Data? {
        let maxSizeInBytes = maxSizeInMB * 1024 * 1024
        var compressionQuality: CGFloat = 1.0
        var imageData: Data?
        while compressionQuality > 0 {
            imageData = image.jpegData(compressionQuality: compressionQuality)
            if let imageData = imageData, Double(imageData.count) <= maxSizeInBytes {
                break
            }
            compressionQuality -= 0.1
        }
        return imageData
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImage.image = selectedImage
            if let imageData = selectedImage.pngData() {
                print("Selected image data: \(imageData)")
                UserDefaults.standard.set(imageData, forKey: "profileImage")
                sendProfileImageToServer(with: imageData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func sendDefaultProfileImageToServer() {
        let url = URL(string: "https://api.jmt-matzip.dev/api/v1/user/defaultProfileImg")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")",
            "Accept": "*/*"
        ]
        
        AF.request(url, method: .post, headers: headers).response { response in
            debugPrint(response)
        }
        //    }
        //
        //    func fetchProfile() {
        //        let urlString = "https://api.jmt-matzip.dev/api/v1/user/info"
        //        let url = URL(string: urlString)!
        //
        //        var accessToken: String?
        //        if UserDefaults.standard.string(forKey: "loginMethod") == "apple" {
        //            accessToken = UserDefaults.standard.string(forKey: "accessToken")
        //        } else if UserDefaults.standard.string(forKey: "loginMethod") == "google" {
        //            accessToken = UserDefaults.standard.string(forKey: "CustomAccessToken")
        //        }
        //
        //        guard let finalToken = accessToken?.trimmingCharacters(in: .whitespacesAndNewlines) else {
        //            print("Access token is nil")
        //            return
        //        }
        //
        //        let headers: HTTPHeaders = [
        //            "Authorization": "Bearer \(finalToken)",
        //            "Content-Type": "application/json"
        //        ]
        //
        //        AF.request(url, method: .get, headers: headers).responseData { [weak self] response in
        //            guard let strongSelf = self else { return }
        //
        //            if let statusCode = response.response?.statusCode, statusCode == 401 {
        //                // 토큰이 만료되었을 경우, 리프레시 토큰을 사용하여 액세스 토큰 재발급 받기
        //                strongSelf.refreshAccessToken { success in
        //                    if success {
        //                        // 새로운 액세스 토큰으로 프로필 정보 다시 가져오기
        //                        strongSelf.fetchProfile()
        //                    } else {
        //                        print("Failed to refresh access token")
        //                    }
        //                }
        //            } else if let data = response.data {
        //                do {
        //                    let profile = try JSONDecoder().decode(UserProfileResponse.self, from: data)
        //                    DispatchQueue.main.async {
        //                        strongSelf.updateProfile(with: profile)
        //                    }
        //                } catch {
        //                    print("Decoding failed with error: \(error)")
        //                }
        //            } else if let error = response.error {
        //                print("Request failed with error: \(error)")
        //            }
        //        }
        //    }
        
        
        //
        //
        //
        //    func updateProfile(with response: UserProfileResponse) {
        //        let nickname = response.data?.nickname
        //        let email = response.data?.email
        //        let imageUrl = response.data?.profileImg
        //
        //        // 닉네임 설정
        //        self.userNickname.text = nickname
        //
        //        // 이메일 설정
        //        self.userEmail.text = email
        //        self.mainTable.reloadData()
        //
        //        // 기본 이미지 설정
        //        let defaultImage = UIImage(named: "DefaultImage")
        //
        //        // 이미지 설정
        //        if let imageUrlString = imageUrl, let imageUrl = URL(string: imageUrlString) {
        //            DispatchQueue.global().async {
        //                if let imageData = try? Data(contentsOf: imageUrl) {
        //                    DispatchQueue.main.async {
        //                        self.profileImage.image = UIImage(data: imageData)
        //                    }
        //                } else {
        //                    DispatchQueue.main.async {
        //                        self.profileImage.image = defaultImage
        //                    }
        //                }
        //            }
        //        } else {
        //            self.profileImage.image = defaultImage
        //        }
        //    }
        //
    }
        @IBAction func changePhoto(_ sender: UIButton) {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let option1Action = UIAlertAction(title: "앨범에서 사진 가져오기", style: .default) { [weak self] (action) in
              //  self?.showImageView(sender)
            }
            
            let option2Action = UIAlertAction(title: "기본 프로필로 변경", style: .default) { [weak self] (action) in
                self?.profileImage.image = UIImage(named: "DefaultImage")
                UserDefaults.standard.removeObject(forKey: "profileImage")
                self?.sendDefaultProfileImageToServer()
                if let imageData = self?.profileImage.image?.pngData() {
                    self?.sendProfileImageToServer(with: imageData)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(option1Action)
            actionSheet.addAction(option2Action)
            actionSheet.addAction(cancelAction)
            
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    
}

extension DetailMyPageVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        // 버전 정보와 1.0.0 라벨이 포함된 StackView를 찾아 제거
        if let stackView = cell.contentView.viewWithTag(12345) as? UIStackView {
            stackView.removeFromSuperview()
        }
        
        cell.textLabel?.text = cellLable[indexPath.row]
        cell.accessoryView = nil
        
        if indexPath.row == cellLable.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            
            let versionInfoLabel = UILabel()
            versionInfoLabel.text = "버전정보"
            versionInfoLabel.textColor = .black
            versionInfoLabel.textAlignment = .left
            
            let versionNumberLabel = UILabel()
            versionNumberLabel.text = "1.0.0"
            versionNumberLabel.textColor = .gray
            versionNumberLabel.textAlignment = .right
            versionNumberLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            
            let stackView = UIStackView(arrangedSubviews: [versionInfoLabel, versionNumberLabel])
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.tag = 12345
            
            versionInfoLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            
            cell.contentView.addSubview(stackView)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 마지막 셀이 아닌 경우 separator를 다시 활성화
        if indexPath.row != cellLable.count - 1 {
            tableView.separatorStyle = .singleLine
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택한 셀의 하이라이트 제거
        
        let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil) // "Main"은 스토리보드 파일 이름에 따라 변경
        
        switch indexPath.row {
        case 0:
            // 첫 번째 셀 선택 시 동작
            //            if let viewController = storyboard.instantiateViewController(withIdentifier: "ServiceTermsViewController") as? ServiceTermsViewController {
            //                self.navigationController?.pushViewController(viewController, animated: true)
            //            }
            print(1)
        case 1:
                print("Attempting to navigate to ServiceTermsViewController")
                if let coordinator = coordinator {
                    coordinator.goToServiceTermsViewController()
                } else {
                    print("Coordinator is nil")
                }
            
        case 2:
            viewModel?.coordinator?.goToServiceUseViewController()

        
        default:
            break
        }
    }
}

