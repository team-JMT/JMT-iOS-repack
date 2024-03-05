//
//  MyPageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class MyPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate

{
    //weak var coordinator: MyPageCoordinator?
    var viewModel: MyPageViewModel?
    private var pageViewControllerTopConstraint: NSLayoutConstraint?

    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var MyPageSegment: UISegmentedControl!
    @IBOutlet weak var MypageMainTableView: UITableView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var NickNameLabel: UILabel!
    
    @IBOutlet weak var registerResturant: UILabel!
    
    
    private var pageViewController: UIPageViewController!
    private var viewControllerIdentifiers: [String] = ["FirstSegmentViewController", "SecondSegmentViewController", "ThirdSegmentViewController"]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewModel = MyPageViewModel()
        
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
        
        MyPageSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        viewModel?.onUserInfoLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        viewModel?.fetchUserInfo()
    }
    
    private func updateUI() {
        if let userInfo = viewModel?.userInfo {
            NickNameLabel.text = userInfo.data?.nickname
            //registerResturant.text = userInfo.data?.email
            if let imageUrl = URL(string: userInfo.data?.profileImg ?? "") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            self.ProfileImage.image = UIImage(data: data)
                            // 이미지 뷰를 원형으로 만듭니다.
                            self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.width / 2
                            self.ProfileImage.clipsToBounds = true // 이 줄은 masksToBounds와 같은 역할을 합니다.
                        }
                    }
                }
            }
            print(NickNameLabel)
        }
    }

    
    
    private func setupLayout() {
        // mainScrollView의 contentSize를 동적으로 계산하기 위해 Auto Layout을 사용합니다.
        mainScrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: HeaderView.bottomAnchor, constant: 10),
            pageViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
    
    private func setupPageViewController() {
        // 페이지 뷰 컨트롤러 설정
            pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageViewController.dataSource = self
            pageViewController.delegate = self

            // 첫 번째 페이지 설정
            if let firstViewController = viewController(for: 0) {
                pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }

            // 페이지 뷰 컨트롤러의 뷰를 contentView에 추가
            addChild(pageViewController)
            contentView.addSubview(pageViewController.view)
            pageViewController.didMove(toParent: self)

            // 페이지 뷰 컨트롤러 뷰의 오토레이아웃 설정
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            pageViewControllerTopConstraint = pageViewController.view.topAnchor.constraint(equalTo: MyPageSegment.bottomAnchor, constant: 10)
            
            NSLayoutConstraint.activate([
                pageViewControllerTopConstraint!,
                pageViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                pageViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                pageViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

    
    
    private func configureScrollView() {
        mainScrollView.delegate = self
        mainScrollView.contentInset.top = MyPageSegment.frame.height + 10 // 세그먼트의 높이만큼 contentInset.top 조정
    }
//    private func configureScrollView() {
//        mainScrollView.delegate = self
//        // 메인 스크롤 뷰의 contentSize 설정
//        mainScrollView.contentSize = CGSize(width: view.frame.width, height: contentView.frame.height)
//    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if let viewController = viewController(for: sender.selectedSegmentIndex) {
            let direction: UIPageViewController.NavigationDirection = .forward
            pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
        }
    }
    
    private func viewController(for index: Int) -> UIViewController? {
        guard index >= 0 && index < viewControllerIdentifiers.count else { return nil }
        return storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[index])
    }
    
    // MARK: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllerIdentifiers.firstIndex(of: viewController.restorationIdentifier ?? ""), viewControllerIndex - 1 >= 0 else { return nil }
        return self.viewController(for: viewControllerIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerIdentifiers.firstIndex(of: viewController.restorationIdentifier ?? ""), viewControllerIndex + 1 < viewControllerIdentifiers.count else { return nil }
        return self.viewController(for: viewControllerIndex + 1)
    }
    
    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = viewControllerIdentifiers.firstIndex(of: visibleViewController.restorationIdentifier ?? "") {
            MyPageSegment.selectedSegmentIndex = index
        }
    }
    
    
    @IBAction func DetailMyPage(_ sender: Any) {
        print("----- DetailMyPage")
        viewModel?.coordinator?.showDetailMyPageVieController()
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        //   updateDataSource(segmentIndex: sender.selectedSegmentIndex)
        
        //   coordinator?.goToDetailView(for: sender.selectedSegmentIndex)
        
    }
    
}

extension MyPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let headerViewHeight = HeaderView.frame.height
        let segmentHeight = MyPageSegment.frame.height
        
        // 세그먼트 컨트롤이 고정될 지점 계산
        let stickyHeaderOffset = headerViewHeight - segmentHeight * 3

        if yOffset > stickyHeaderOffset {
            // 세그먼트 컨트롤을 상단에 고정
            MyPageSegment.transform = CGAffineTransform(translationX: 0, y: yOffset - stickyHeaderOffset)
            // 고정된 세그먼트 컨트롤 아래로 컨텐츠가 시작되도록 조정
            scrollView.contentInset.top = segmentHeight
        } else {
            // 초기 위치로 복원
            MyPageSegment.transform = .identity
            scrollView.contentInset.top = 0
        }

        // 페이지 뷰 컨트롤러 뷰의 위치 조정
        let pageViewTopOffset = max(0, yOffset - stickyHeaderOffset + segmentHeight + 10)
        pageViewControllerTopConstraint?.constant = pageViewTopOffset
        
        
    }
}
