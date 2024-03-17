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
        
        
        viewModel.onRestaurantsDataUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.mainTable.reloadData()
                }
            }
            
            viewModel.fetchUserInfo()
        print("123123")
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(viewModel.restaurantsData.count)
        print("---")
        return viewModel.restaurantsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageRegisterResturantTableViewCell", for: indexPath) as? MyPageRegisterResturantTableViewCell else {
            return UITableViewCell()
        }
        
        let restaurant = viewModel.restaurantsData[indexPath.row]
        cell.configure(with: restaurant)
        
        return cell
    }

}
