//
//  FirstSegmentViewController.swift
//  JMTeng
//
//  Created by 이지훈 on 2/16/24.
//

import UIKit

class FirstSegmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(1)
        mainTable.delegate = self
        mainTable.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageRegisterResturantTableViewCell", for: indexPath) as? MyPageRegisterResturantTableViewCell else {
            return UITableViewCell()
        }
        
        // 여기에서 cell의 레이블 등을 설정
        cell.resturantLabel?.text = "Restaurant \(indexPath.row + 1)"
        cell.grouplabel?.text = "Group \(indexPath.row + 1)"
        cell.categoryLable?.text = "Category \(indexPath.row + 1)"
        cell.MyNickname?.text = "Nickname \(indexPath.row + 1)"
        
        
        return cell
    }
    
    
}
