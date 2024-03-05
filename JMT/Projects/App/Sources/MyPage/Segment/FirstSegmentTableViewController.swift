//
//  FirstSegmentTableViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 3/5/24.
//

import UIKit
import Alamofire

class FirstSegmentTableViewController: UITableViewController {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resturantName: UILabel!
    
    
    var restaurants: [Restaurant] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    

        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return restaurants.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
            let restaurant = restaurants[indexPath.row]
            cell.textLabel?.text = restaurant.name


            return cell
        }
    }
