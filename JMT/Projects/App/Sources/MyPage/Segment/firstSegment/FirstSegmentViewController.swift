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
    
    private var keychainAccess: KeychainAccessible = DefaultKeychainAccessible()
    
    
    //필터링용
    var selectedDistance: String = "가까운순"
    var selectedType: String = ""
    var selectedAlcohol: Bool = false
    
    
    @IBOutlet weak var registerHeaderView: UIView!
    
    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var alcholrFilterView: UIView!
    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var nearFilterView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var alcholLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var distanceButton: UIButton!

    @IBOutlet weak var alcholBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTable.delegate = self
        mainTable.dataSource = self
        
        layout()
        
        
        viewModel.onRestaurantsDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.mainTable.reloadData()
            }
        }
        
        viewModel.fetchUserInfo()
        print("123123")
        
        distanceButton.addTarget(self, action: #selector(showDistanceMenuAction), for: .touchUpInside)
        typeBtn.addTarget(self, action: #selector(showTypeMenuAction), for: .touchUpInside)
        alcholBtn.addTarget(self, action: #selector(showAlcoholMenuAction), for: .touchUpInside)
        
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
    
    func fetchRestaurants() {
        print("Fetching restaurants with selectedType: \(selectedType), selectedAlcohol: \(selectedAlcohol)")
        
        guard let accessToken = keychainAccess.getToken("accessToken") else {
            print("Access Token is not available")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let url = "https://api.jmt-matzip.dev/api/v1/restaurant/search?page=0&size=20"
        
        let parameters: [String: Any] = [
            "userLocation": [
                "x": "127.0596",
                "y": "37.6633"
            ],
            "filter": [
                "categoryFilter": selectedType, // 이제 선택된 타입을 사용합니다.
                "isCanDrinkLiquor": selectedAlcohol // 선택된 알코올 정보를 사용합니다.
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ResturantResponse.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(let responseData):
                print("Successfully fetched restaurants data")
                self.viewModel.restaurantsData = responseData.data?.restaurants ?? []
                DispatchQueue.main.async {
                    self.mainTable.reloadData()
                }
            case .failure(let error):
                print("Error fetching restaurants data: \(error)")
            }
        }
    }
    
    
    
    //가까운순 필터링
    
    @objc func showDistanceMenuAction() {
        let actions = [
            UIAction(title: "가까운순", handler: { [weak self] _ in self?.handleDistanceFilterChange("가까운순") }),
            UIAction(title: "좋아요", handler: { [weak self] _ in self?.handleDistanceFilterChange("좋아요") }),
            UIAction(title: "최신순", handler: { [weak self] _ in self?.handleDistanceFilterChange("최신순") })
        ]
        distanceButton.menu = UIMenu(title: "", children: actions)
        distanceButton.showsMenuAsPrimaryAction = true
        print(1)
    }
    
    @objc func showTypeMenuAction() {
        let foodTypes: [FoodType] = [
            FoodType(filter: .KOREA),
            FoodType(filter: .JAPAN),
            FoodType(filter: .CHINA),
            FoodType(filter: .FOREIGN),
            FoodType(filter: .CAFE),
            FoodType(filter: .BAR),
            FoodType(filter: .ETC)
        ]
        
        let actions = foodTypes.map { foodType in
            UIAction(title: foodType.name, image: nil) { [weak self] _ in
                self?.selectedType = foodType.filter.rawValue
                self?.typeLabel.text = foodType.name
                self?.fetchRestaurants()
            }
        }
        
        typeBtn.menu = UIMenu(title: "", children: actions)
        typeBtn.showsMenuAsPrimaryAction = true
    }
    
    
    
    
    @objc func showAlcoholMenuAction() {
        let actions = [
            UIAction(title: "주류가능", handler: { [weak self] _ in self?.handleAlcoholFilterChange(true) }),
            UIAction(title: "주류불가능/모름", handler: { [weak self] _ in self?.handleAlcoholFilterChange(false) })
        ]
        
        alcholBtn.menu = UIMenu(title: "", children: actions)
        alcholBtn.showsMenuAsPrimaryAction = true
    }
    
    func handleDistanceFilterChange(_ filter: String) {
        selectedDistance = filter
        distanceLabel.text = filter
        fetchRestaurants()
    }
    
    func handleAlcoholFilterChange(_ canDrink: Bool) {
        selectedAlcohol = canDrink
        alcholLabel.text = canDrink ? "주류가능" : "주류불가능/모름"
        fetchRestaurants()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.restaurantsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageRegisterResturantTableViewCell", for: indexPath) as? MyPageRegisterResturantTableViewCell else {
            return UITableViewCell()
        }
        
        let restaurant = viewModel.restaurantsData[indexPath.row]
        cell.configure(with: restaurant)
        
        
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

