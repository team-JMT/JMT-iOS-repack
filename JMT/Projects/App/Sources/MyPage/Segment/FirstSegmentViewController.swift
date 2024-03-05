//
//  FirstSegmentViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/16/24.
//

import UIKit
import Alamofire


class FirstSegmentViewController: UIViewController {

    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTable.dataSource = self
        
        fetchRestaurants()
    }

    func fetchRestaurants() {
        guard let token = DefaultKeychainAccessible().getToken("AccessToken") else { return }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let url = "https://api.jmt-matzip.dev/api/v1/restaurant/search/6?page=0&size=20"
        
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: RestaurantResponse.self) { response in
            switch response.result {
            case .success(let restaurantResponse):
                self.restaurants = restaurantResponse.data.restaurants
                DispatchQueue.main.async {
                    self.mainTable.reloadData()
                }
            case .failure(let error):
                print("Error fetching restaurants: \(error.localizedDescription)")
            }
        }
    }

}

extension FirstSegmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = "\(restaurant.name) - \(restaurant.category)"
        cell.detailTextLabel?.text = "Distance: \(restaurant.differenceInDistance)"
        return cell
    }
}
