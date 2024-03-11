//
//  SecondSegmentViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/16/24.
//

import UIKit

struct RestaurantData {
    var imageName: String
    var description: String
}

let dummyData = [
    RestaurantData(imageName: "Xmark", description: "알겠습니다! 이번엔 정확히 100글자가 되도록 문장을 준비해 보았습니다: 행복은 멀리 있는 것이 아니라, 우리가 살아가는 순간순간 속에서 찾을 수 있는 것. 매일을 감사하며 살아가는 것이 진정한 행복의 비결입니다. 확인해 보시고, 필요하시면 언제든지 조정 요청해주세요!ㅇㅇ"),
    RestaurantData(imageName: "restaurant2", description: "Here is the second restaurant."),
    RestaurantData(imageName: "restaurant3", description: "A lovely place for dinner."),
    RestaurantData(imageName: "restaurant4", description: "Famous for its cozy atmosphere."),
    RestaurantData(imageName: "restaurant5", description: "Don't miss our special dishes!")
]


class SecondSegmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSegmentTableViewCell", for: indexPath) as! SecondSegmentTableViewCell
        let data = dummyData[indexPath.row]
        cell.Resturantexplanation.text = data.description
        cell.ResturantImage.image = UIImage(named: data.imageName)
        return cell
    }
    
}
