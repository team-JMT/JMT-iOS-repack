//
//  SecondSegmentViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/16/24.
//

import UIKit
import Alamofire


class SecondSegmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private let keychainAccess: KeychainAccessible

    var imageNames: [String] = [] // 이미지 이름 배열을 저장할 프로퍼티 추가
//    var reviews: [Review] = [] // 서버에서 받아온 리뷰 데이터를 저장할 배열

    var viewModel: MyPageViewModel?

    @IBOutlet weak var likedReply: UITableView!
    
    @IBOutlet weak var nearfilterView: UIView!
    @IBOutlet weak var typeFilterView: UIView!
    @IBOutlet weak var alcholrFilterView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedReply.delegate = self
        likedReply.dataSource = self
        layout()
        fetchReviews()

        
        
    }
    
    // DI를 통한 초기화
    init(keychainAccess: KeychainAccessible = DefaultKeychainAccessible()) {
        self.keychainAccess = keychainAccess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.keychainAccess = DefaultKeychainAccessible()
        super.init(coder: coder)
    }
    
    
    func layout() {
        nearfilterView.layer.cornerRadius = nearfilterView.frame.height / 2
        nearfilterView.clipsToBounds = true
        
        typeFilterView.layer.cornerRadius = typeFilterView.frame.height / 2
        typeFilterView.clipsToBounds = true
        
        alcholrFilterView.layer.cornerRadius = alcholrFilterView.frame.height / 2
        alcholrFilterView.clipsToBounds = true
    }
    
    
    func fetchReviews() {
        let url = "https://api.jmt-matzip.dev/api/v1/restaurant/my/review?page=1&size=20" //"https://api.jmt-matzip.dev/api/v1/restaurant/my/review?page=1&size=20"

        
        guard let accessToken = keychainAccess.getToken("accessToken") else {
            print("Access Token is not available")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let x = viewModel?.locationManager.coordinate?.longitude ?? 0.0
        let y = viewModel?.locationManager.coordinate?.latitude ?? 0.0
        
        print("===", x,y)
        
        let parameters: [String: Any] = [
            "userLocation": ["x": "\(x)", "y": "\(y)"],
            "filter": ["categoryFilter": nil, "isCanDrinkLiquor": nil]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let reviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: data)
                    
                    print("==== res", reviewResponse.data)
                    
                    self.viewModel?.testReviews = reviewResponse.data.reviewList
                    print("====== Successfully decoded response: \(reviewResponse)") // 네트워크 응답 확인
                    self.updateReviewData()
                } catch {
                    print("Decoding error: \(error)") // 모델 디코딩 확인
                }
            case .failure(let error):
                print("Request error: \(error)")
            }
        }
    }

    func updateReviewData() {
        DispatchQueue.main.async {
            self.likedReply.reloadData()
        }
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.testReviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSegmentTableViewCell", for: indexPath) as? SecondSegmentTableViewCell else {
            fatalError("Cell not found")
        }
        let target = viewModel?.testReviews[indexPath.row]
        cell.configure(with: target)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel?.testReviews[]
//
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPageReviewCollectionViewCell", for: indexPath) as? myPageReviewCollectionViewCell else {
//            fatalError("Unable to dequeue myPageReviewCollectionViewCell")
//        }
//
//        let review = reviews[indexPath.section]
//        let imageUrl = review.reviewImages[indexPath.item]
//
//        return cell
//    }

}

