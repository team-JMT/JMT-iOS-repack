//
//  MyPageTestViewController.swift
//  App
//
//  Created by 이지훈 on 1/18/24.
//

import UIKit
import Alamofire


class DetailMyPageVC : UIViewController {
    
   // weak var coordinator: DetailMyPageCoordinator?
    var viewModel: DetailMyPageViewModel?
    
    
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mainTable: UITableView!
    
    let cellName = "ProfileCell"
    let cellLable: Array<String> = ["계정관리", "서비스 이용동의", "개인정보 처리방식"," "]
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setCustomNavigationBarBackButton(isSearchVC: false)
    }

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
        
        
        userEmail.lineBreakMode = .byTruncatingMiddle
        
        mainTable.separatorStyle = .singleLine
        updateUI()
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func updateUI() {
        if let userInfo = viewModel?.userInfo {
            userNickname.text = userInfo.data?.nickname
            userEmail.text = userInfo.data?.email
            if let imageUrl = URL(string: userInfo.data?.profileImg ?? "") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            self.profileImage.image = UIImage(data: data)
                            // 이미지 뷰를 원형으로 만듭니다.
                            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
                            self.profileImage.clipsToBounds = true // 이 줄은 masksToBounds와 같은 역할을 합니다.
                        }
                    }
                }
            }
            print(userNickname)
        }
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
        
        //let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil) // "Main"은 스토리보드 파일 이름에 따라 변경
        
        switch indexPath.row {
        case 0:
            viewModel?.coordinator?.showMyPageManageViewController()
        case 1:
            viewModel?.coordinator?.showMyPageServiceTermsViewController()
        case 2:
            viewModel?.coordinator?.showMyPageServiceUseVC()

        
        default:
            break
        }
    }
}

