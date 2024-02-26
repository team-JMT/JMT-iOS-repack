////
////  MyPageViewController.swift
////  App
////
////  Created by PKW on 2023/12/22.
////
//
//import UIKit
//
//class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate
//
//{
//    
//    @IBOutlet weak var HeaderView: UIView!
//    @IBOutlet weak var MyPageSegment: UISegmentedControl!
//    @IBOutlet weak var MypageMainTableView: UITableView!
//    
//    @IBOutlet weak var ProfileImage: UIImageView!
//    
//    @IBOutlet weak var NickNameLabel: UILabel!
//    
//    @IBOutlet weak var registerResturant: UILabel!
//    
//    
//    
//    weak var coordinator: MyPageCoordinator?
//    var viewModel: MyPageViewModel?
//    
//    private var pageViewController: UIPageViewController!
//    private var viewControllerIdentifiers: [String] = ["FirstSegmentViewController", "SecondSegmentViewController", "ThirdSegmentViewController"]
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        viewModel = MyPageViewModel()
////        
////        MypageMainTableView.delegate = self
////        MypageMainTableView.dataSource = self
//        
//        
//        self.MyPageSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
//        self.MyPageSegment.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.foregroundColor: UIColor.gray900,
//                .font: UIFont(name: "Pretendard-Bold", size: 14)
//            ],
//            for: .selected
//        )
//        self.MyPageSegment.selectedSegmentIndex = 0
//        
//        //   self.changeValue(control: self.segmentedControl)
//        
//        
//        setupPageViewController()
//        
//        MyPageSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
//       
//        viewModel?.onUserInfoLoaded = { [weak self] in
//            DispatchQueue.main.async {
//                self?.updateUI()
//            }
//        }
//        viewModel?.fetchUserInfo()
//    }
//    
//    private func updateUI() {
//        if let userInfo = viewModel?.userInfo {
//            NickNameLabel.text = userInfo.data?.nickname
//            registerResturant.text = userInfo.data?.email
//            if let imageUrl = URL(string: userInfo.data?.profileImg ?? "0") {
//
//                print(NickNameLabel)
//                print(registerResturant)
//                print(imageUrl)
//                print("--")
//            }
//        }
//    }
//    
//    private func setupPageViewController() {
//        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//        
//        if let firstViewController = viewController(for: 0) {
//            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
//        }
//        
//        addChild(pageViewController)
//        view.addSubview(pageViewController.view)
//        pageViewController.didMove(toParent: self)
//        
//        // 페이지 뷰 컨트롤러의 뷰 제약 조건 설정
//        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            pageViewController.view.topAnchor.constraint(equalTo: MyPageSegment.bottomAnchor, constant: 10),
//            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
//        if let viewController = viewController(for: sender.selectedSegmentIndex) {
//            let direction: UIPageViewController.NavigationDirection = .forward // 실제 방향을 계산하려면 현재 페이지 인덱스를 기록해야 합니다.
//            pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
//        }
//    }
//    
//    private func viewController(for index: Int) -> UIViewController? {
//        guard index >= 0 && index < viewControllerIdentifiers.count else { return nil }
//        return storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[index])
//    }
//    
//    // MARK: UIPageViewControllerDataSource
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        
//        guard let viewControllerIndex = viewControllerIdentifiers.firstIndex(of: viewController.restorationIdentifier ?? ""), viewControllerIndex - 1 >= 0 else { return nil }
//        return self.viewController(for: viewControllerIndex - 1)
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = viewControllerIdentifiers.firstIndex(of: viewController.restorationIdentifier ?? ""), viewControllerIndex + 1 < viewControllerIdentifiers.count else { return nil }
//        return self.viewController(for: viewControllerIndex + 1)
//    }
//    
//    // MARK: UIPageViewControllerDelegate
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = viewControllerIdentifiers.firstIndex(of: visibleViewController.restorationIdentifier ?? "") {
//            MyPageSegment.selectedSegmentIndex = index
//        }
//    }
//    
//    
//    @IBAction func DetailMyPage(_ sender: Any) {
//        coordinator?.goToDetailMyPageView()
//    }
//    
//    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
//        //   updateDataSource(segmentIndex: sender.selectedSegmentIndex)
//        MypageMainTableView.reloadData()
//        
//        //   coordinator?.goToDetailView(for: sender.selectedSegmentIndex)
//        
//    }
//    
//    // 테이블 뷰 데이터 소스 및 델리게이트 메서드
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // 세그먼트 선택에 따른 콘텐츠 셀 1개만 표시
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell
//        
//        // 이전에 추가된 뷰 제거
//        cell?.contentView.subviews.forEach { $0.removeFromSuperview() }
//        
//        return cell!
//    }
//}
