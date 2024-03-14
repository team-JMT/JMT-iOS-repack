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

    @IBOutlet weak var registerHeaderView: UIView!
    
    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var alcholrFilterView: UIView!
    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var nearFilterView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var distanceButton: UIButton!
    
    @IBOutlet weak var alcholLabel: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var alcholBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        layout()
        
        
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
    
        
    
    
    func layout() {
        nearFilterView.layer.cornerRadius = nearFilterView.frame.height / 2
        nearFilterView.clipsToBounds = true
        
        typeFilterView.layer.cornerRadius = typeFilterView.frame.height / 2
        typeFilterView.clipsToBounds = true
        
        alcholrFilterView.layer.cornerRadius = alcholrFilterView.frame.height / 2
        alcholrFilterView.clipsToBounds = true
    }
    
    
    
    //가까운순 필터링
//    @objc func showDistanceMenu() {
//        let action1 = UIAction(title: "가까운순", image: nil, identifier: nil) { [weak self] action in
//            print("가까운순 selected")
//            self?.distanceLabel.text = "가까운순"
//            self?.fetchRestaurants(){}
//            
//        }
//        
//        let action2 = UIAction(title: "좋아요", image: nil, identifier: nil) { action in
//            print("좋아요 selected")
//            self.distanceLabel.text = "좋아요"
//            self.fetchRestaurants(){}
//            
//            
//        }
//        
//        let action3 = UIAction(title: "최신순", image: nil, identifier: nil) { action in
//            print("최신순 selected")
//            
//            self.distanceLabel.text = "최신순"
//            self.fetchRestaurants(){}
//            
//            
//        }
//        
//        let menu = UIMenu(image: nil, identifier: nil, children: [action1, action2, action3])
//        
//        distanceButton.menu = menu
//        distanceButton.showsMenuAsPrimaryAction = true
//        
//    }
    
    
    //종류 필터링
//    @objc func showTypeMenu() {
//        let foodTypes: [FoodType] = [
//            FoodType(filter: .KOREA),
//            FoodType(filter: .JAPAN),
//            FoodType(filter: .CHINA),
//            FoodType(filter: .FOREIGN),
//            FoodType(filter: .CAFE),
//            FoodType(filter: .BAR),
//            FoodType(filter: .ETC)
//        ]
//        print("Selected type: \(selectedType)")
//        
//        let actions = foodTypes.map { foodType -> UIAction in
//            return UIAction(title: foodType.name, image: foodType.image, identifier: nil) { [weak self] action in
//                print("\(foodType.filter.rawValue) selected")
//                self?.typeLabel.text = foodType.name
//                
//                //필터링으로 나눈것 가져오기
//                self?.selectedType = foodType.identifier
//                
//                // 필터링된 데이터를 다시 불러옵니다.
//                self?.fetchRestaurants(){
//                    DispatchQueue.main.async {
//                        self?.registerResturantTV.reloadData()
//                    }
//                }
//            }
//            print(self.restaurants)
//            
//        }
//        
//        let menu = UIMenu(image: nil, identifier: nil, children: actions)
//        
//        typeBtn.menu = menu
//        typeBtn.showsMenuAsPrimaryAction = true
//    }
    
    
    
    
    
    
//    //주류여부 필터링
//    @objc func showAlcoholMenu() {
//        let action1 = UIAction(title: "주류가능", image: nil, identifier: nil) { [weak self] action in
//            // Handle action here for Beer
//            print("주류가능 selected")
//            self?.alcholLabel.text = "주류가능"
//            self?.fetchRestaurants() {
//                DispatchQueue.main.async {
//                    self?.registerResturantTV.reloadData()
//                }
//                self?.updateFilterViewSize()
//                
//            }
//            
//            
//        }
//        
//        let action2 = UIAction(title: "주류불가능/모름", image: nil, identifier: nil) { [weak self] action in
//            // Handle action here for Wine
//            print("주류불가능/모름 selected")
//            self?.alcholLabel.text = "주류불가능/모름"
//            self?.fetchRestaurants() {
//                DispatchQueue.main.async {
//                    self?.mainTable.reloadData()
//                }
//                self?.updateFilterViewSize()
//                
//            }
//            
//            
//        }
//        
//        
//        
//        let menu = UIMenu(image: nil, identifier: nil, children: [action1, action2])
//        
//        alcholBtn.menu = menu
//        alcholBtn.showsMenuAsPrimaryAction = true
//    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageRegisterResturantTableViewCell", for: indexPath) as? MyPageRegisterResturantTableViewCell else {
            return UITableViewCell()
        }
        
        cell.MyNickname?.text = viewModel.userInfo?.data?.nickname

        if let userInfo = viewModel.userInfo?.data {
            if let imageUrl = URL(string: userInfo.profileImg) {
                AF.request(imageUrl).responseData { [weak cell] response in
                    switch response.result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell?.myPageImage?.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        return cell
    }

}
