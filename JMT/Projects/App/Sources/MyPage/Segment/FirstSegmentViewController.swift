//
//  FirstSegmentViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/16/24.
//

import UIKit
import Alamofire

class FirstSegmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //따로 뷰모델을 만들지않고 참조만 하기
   lazy var viewModel = MyPageViewModel()

    
    @IBOutlet weak var mainTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(1)
        mainTable.delegate = self
        mainTable.dataSource = self
        
        viewModel = MyPageViewModel()
        viewModel.onUserInfoLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.mainTable.reloadData()
            }
        }
        viewModel.fetchUserInfo()
    }
    
    
    
    
    func getUserInfo() {
        UserInfoAPI.getLoginInfo { response in
            switch response {
            case .success(let info):
               print(1)
            case .failure(let error):
                print("getUserInfo 실패!!", error)
              //self.onFailure?()
            }
        }
    }
    
        
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageRegisterResturantTableViewCell", for: indexPath) as? MyPageRegisterResturantTableViewCell else {
            return UITableViewCell()
        }
        
        // ViewModel에서 사용자 정보 가져와서 설정
        if let userInfo = viewModel.userInfo?.data {
            cell.MyNickname?.text = userInfo.nickname
//            
//            if let imageUrl = URL(string: userInfo.profileImg) {
//                cell.imageView?.af.setImage(withURL: imageUrl) // AlamofireImage 사용하여 이미지 로딩
//            }
        }
        
        return cell
    }
    
}
