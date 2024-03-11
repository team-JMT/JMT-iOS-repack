//
//  MyPageTestViewController.swift
//  App
//
//  Created by 이지훈 on 1/18/24.
//

import UIKit
import Alamofire


class DetailMyPageVC : UIViewController {
    
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
        
        // 사용자 정보 다시 가져오기
        viewModel?.fetchUserInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            profileImage.layer.cornerRadius = profileImage.layer.frame.size.width / 2
           profileImage.contentMode = .scaleAspectFill
           profileImage.clipsToBounds = true

           mainTable.delegate = self
           mainTable.dataSource = self

        userEmail.lineBreakMode = .byTruncatingMiddle
           mainTable.separatorStyle = .singleLine

           viewModel?.onUserInfoLoaded = { [weak self] in
               self?.updateUI()
           }

           viewModel?.fetchUserInfo()
        
        //닉네임 변경 노티
        NotificationCenter.default.addObserver(self, selector: #selector(showNicknameUpdateSuccessToast), name: NSNotification.Name("NicknameUpdateSuccess"), object: nil)
        //이미지 변경 노티
        NotificationCenter.default.addObserver(self, selector: #selector(profileImageUpdated), name: NSNotification.Name("ProfileImageUpdated"), object: nil)


    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
                            self.profileImage.clipsToBounds = true
                            
                        }
                    }
                }
            }
       
        }
    }
    
    func showToastWithCustomLayout(message: String, duration: TimeInterval = 2.0) {
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
    
    @objc func showNicknameUpdateSuccessToast() {
        showToastWithCustomLayout(message: "닉네임이 성공적으로 변경되었습니다.", duration: 2.0)
    }

    @objc func profileImageUpdated() {
        // 이미지 변경 성공 토스트 메시지 표시
        showToastWithCustomLayout(message: "프로필 이미지가 성공적으로 변경되었습니다.", duration: 2.0)
        viewModel?.fetchUserInfo()

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
        viewModel?.coordinator?.showProfileImagePopupViewController()
    }
    
    
    @IBAction func changeNickname(_ sender: Any) {
        viewModel?.coordinator?.showMyPageChangeNicknameVC()
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

