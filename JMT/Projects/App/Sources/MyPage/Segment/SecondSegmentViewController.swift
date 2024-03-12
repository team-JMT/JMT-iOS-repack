//
//  SecondSegmentViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/16/24.
//

import UIKit

struct RestaurantData {
    var imageName: [String]
    var description: String
}

let dummyData = [
    RestaurantData(imageName: ["dummyIcon","dummyIcon","dummyIcon","Xmark","dummyIcon","dummyIcon","Xmark","dummyIcon","Xmark","Xmark"], description: "알겠습니다! 이번엔 정확히 100글자가 되도록 문장을 준비해 보았습니다: 행복은 멀리 있는 것이 아니라, 우리가 살아가는 순간순간 속에서 찾을 수 있는 것. 매일을 감사하며 살아가는 것이 진정한 행복의 비결입니다. 확인해 보시고, 필요하시면 언제든지 조정 요청해주세요!ㅇㅇ"),
    RestaurantData(imageName: ["Xmark", "Xmark", "Xmark", "Xmark", "Xmark", "Xmark", "Xmark", "XmarkXmark", "Xmark", "Xmark"], description: "알겠습니다! 이번엔 정확히 100글자가 ..."),
    RestaurantData(imageName: ["restaurant3"], description: "A lovely place for dinner."),
    RestaurantData(imageName: ["restaurant4"], description: "Famous for its cozy atmosphere."),
    RestaurantData(imageName: ["restaurant5"], description: "Don't miss our special dishes!")
]


class SecondSegmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource {
   
    var imageNames: [String] = [] // 이미지 이름 배열을 저장할 프로퍼티 추가

    @IBOutlet weak var likedReply: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedReply.delegate = self
        likedReply.dataSource = self

    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSegmentTableViewCell", for: indexPath) as? SecondSegmentTableViewCell else {
            fatalError("Cell not found")
        }
        let data = dummyData[indexPath.row]
        cell.configure(with: data)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
        print("===")
        print(imageNames.count)

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPageReviewCollectionViewCell", for: indexPath) as? myPageReviewCollectionViewCell else {
            fatalError("Unable to dequeue myPageReviewCollectionViewCell")
        }
        let imageName = imageNames[indexPath.row]
        cell.configure(imageName: imageName)
        return cell
    }
    
}

