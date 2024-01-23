//
//  MyPageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
    
 {
    
    var viewModel: MyPageViewModel?
    
    var dataSource: [DummyDataType] = []

    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var MyPageSegment: UISegmentedControl!
    @IBOutlet weak var MypageMainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MypageMainTableView.delegate = self
        MypageMainTableView.dataSource = self

        updateDataSource(segmentIndex: MyPageSegment.selectedSegmentIndex)
        
        
        self.MyPageSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
            self.MyPageSegment.setTitleTextAttributes(
              [
                NSAttributedString.Key.foregroundColor: UIColor.green,
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
              ],
              for: .selected
            )
            self.MyPageSegment.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
            updateDataSource(segmentIndex: sender.selectedSegmentIndex)
        MypageMainTableView.reloadData()
        
        }
    
    

    
    func updateDataSource(segmentIndex: Int) {
           if segmentIndex == 0 {
               dataSource = [
                DummyDataType(image: "image1", labelText: "레스토랑 1"),
                DummyDataType(image: "image1", labelText: "레스토랑 2"),
                DummyDataType(image: "image1", labelText: "레스토랑 3"),
                DummyDataType(image: "image1", labelText: "레스토랑 3"),
               ]
           } else if segmentIndex == 1 {
               dataSource = [
                DummyDataType(image: "image1", labelText: " 4"),
                DummyDataType(image: "image1", labelText: "레스토랑 5"),
                DummyDataType(image: "image1", labelText: "레스토랑 6"),
               ]
           } else if segmentIndex == 2 {
               dataSource = [
                DummyDataType(image: "image1", labelText: " 5"),
                DummyDataType(image: "image1", labelText: "레스토랑 5"),
                DummyDataType(image: "image1", labelText: "레스토랑 6"),
               ]
           }
       }

     
        // 테이블 뷰 데이터 소스 및 델리게이트 메서드
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else {
                return UITableViewCell()
            }
            let data = dataSource[indexPath.row]
            // 셀 구성
            cell.configure(with: data)
            return cell
        }
    
//    @IBAction func gotoNext(_ sender: Any) {
//        print(0)
//        viewModel?.gotoNext()
//        print(10)
//    }
    
    
}
