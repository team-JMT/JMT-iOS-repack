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
            // userInfo를 통해 이미지 URL에 접근
            if let imageUrl = URL(string: userInfo.profileImg) {
                // Alamofire의 responseData 메서드를 사용하여 이미지 데이터 다운로드
                AF.request(imageUrl).responseData { [weak cell] response in
                    switch response.result {
                    case .success(let data):
                        // 메인 스레드에서 이미지 뷰에 이미지 설정
                        DispatchQueue.main.async {
                            // 셀이 재사용되어 다른 인덱스 패스에 사용될 수 있으므로, 현재 셀이 여전히 보여줘야 할 이미지를 로딩 중인지 확인 필요
                            cell?.myPageImage?.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        // 오류 처리 또는 기본 이미지 설정
                        print(error)
                    }
                }
            }
        }
        
        return cell
    }

}
