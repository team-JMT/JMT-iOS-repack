//
//  MyPageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate
    
 {
   
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var MyPageSegment: UISegmentedControl!
    @IBOutlet weak var MypageMainTableView: UITableView!
    
    
     weak var coordinator: MyPageCoordinator?
     var viewModel: MyPageViewModel?

    private var pageViewController: UIPageViewController!

    private lazy var viewControllerList: [UIViewController] = {
            let vc1 = UIViewController()
            vc1.view.backgroundColor = .red
            let vc2 = UIViewController()
            vc2.view.backgroundColor = .green
            let vc3 = UIViewController()
            vc3.view.backgroundColor = .blue
            return [vc1, vc2, vc3]
        }()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MypageMainTableView.delegate = self
        MypageMainTableView.dataSource = self

        
        self.MyPageSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
            self.MyPageSegment.setTitleTextAttributes(
              [
                NSAttributedString.Key.foregroundColor: UIColor.gray900,
                .font: UIFont(name: "Pretendard-Bold", size: 14)
              ],
              for: .selected
            )
            self.MyPageSegment.selectedSegmentIndex = 0
        
        setupPageViewController()
        setupSegmentedControl()
        viewModel = MyPageViewModel()
//
//                // 로그인 상태 체크
//        viewModel?.checkLoginStatus()
//        
//        viewModel?.fetchTokens()
//        viewModel?.getUserInfo()
    }
    
    
    private func setupPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        // Set the initial view controller from your array
        if let firstViewController = viewControllerList.first {
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // Add pageViewController as a child view controller
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        // Set pageViewController's constraints or frame
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: MyPageSegment.bottomAnchor, constant: 10),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSegmentedControl() {
        MyPageSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex < viewControllerList.count {
            let selectedVC = viewControllerList[sender.selectedSegmentIndex]
            let direction: UIPageViewController.NavigationDirection = sender.selectedSegmentIndex > currentPage ? .forward : .reverse
            pageViewController.setViewControllers([selectedVC], direction: direction, animated: true, completion: nil)
        }
    }
    
    var currentPage: Int {
        guard let vc = pageViewController.viewControllers?.first else { return 0 }
        return viewControllerList.firstIndex(of: vc) ?? 0
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return viewControllerList[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerList.firstIndex(of: viewController), index + 1 < viewControllerList.count else { return nil }
        return viewControllerList[index + 1]
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            MyPageSegment.selectedSegmentIndex = currentPage
        }
    }
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
     //   updateDataSource(segmentIndex: sender.selectedSegmentIndex)
        MypageMainTableView.reloadData()
        
        coordinator?.goToDetailView(for: sender.selectedSegmentIndex)

        }
    
    

    
//    func updateDataSource(segmentIndex: Int) {
//           if segmentIndex == 0 {
//               dataSource = [
//                DummyDataType(image: "image1", labelText: "레스토랑 1"),
//                DummyDataType(image: "image1", labelText: "레스토랑 2"),
//                DummyDataType(image: "image1", labelText: "레스토랑 3"),
//                DummyDataType(image: "image1", labelText: "레스토랑 3"),
//               ]
//           } else if segmentIndex == 1 {
//               dataSource = [
//                DummyDataType(image: "image1", labelText: " 4"),
//                DummyDataType(image: "image1", labelText: "레스토랑 5"),
//                DummyDataType(image: "image1", labelText: "레스토랑 6"),
//               ]
//           } else if segmentIndex == 2 {
//               dataSource = [
//                DummyDataType(image: "image1", labelText: " 5"),
//                DummyDataType(image: "image1", labelText: "레스토랑 5"),
//                DummyDataType(image: "image1", labelText: "레스토랑 6"),
//               ]
//           }
//       }

     
        // 테이블 뷰 데이터 소스 및 델리게이트 메서드
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else {
                return UITableViewCell()
            }
           // let data = dataSource[indexPath.row]
            // 셀 구성
         //   cell.configure(with: data)
            return UITableViewCell()
        }
    
//    @IBAction func gotoNext(_ sender: Any) {
//        print(0)
//        viewModel?.gotoNext()
//        print(10)
//    }
    
    
}
