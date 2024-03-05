//
//  MyPageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class MyPageViewController: UIViewController, UIScrollViewDelegate

{
    
    var viewModel: MyPageViewModel?
    private var pageViewControllerTopConstraint: NSLayoutConstraint?
    
    // 고정 헤더 뷰 내 세그먼트 컨트롤
    private var fixedSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var MyPageSegment: UISegmentedControl!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var NickNameLabel: UILabel!
    
    @IBOutlet weak var registerResturant: UILabel!
    
    @IBOutlet weak var containerViewTopConstrains: NSLayoutConstraint!
    
    @IBOutlet weak var fixedHeaderView: UIView!
    
    private var currentViewController: UIViewController?
    
    
    // private var pageViewController: UIPageViewController!
    private var viewControllerIdentifiers: [String] = ["FirstSegmentViewController", "SecondSegmentViewController", "ThirdSegmentViewController"]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // mainScrollView의 contentSize를 동적으로 계산
        let contentHeight = HeaderView.frame.height + containerView.frame.height
        mainScrollView.contentSize = CGSize(width: contentView.frame.width, height: contentHeight)
    }
    
    
    let fixedHeaderViewHeight: CGFloat = 80 // 고정될 뷰의 높이
    let triggerOffset: CGFloat = 150 // 고정 뷰가 나타나기 시작할 스크롤 위치

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        setupFixedHeaderView()
        switchToViewController(at: MyPageSegment.selectedSegmentIndex)
        
    }
    
    
    func setupFixedHeaderView() {
        fixedHeaderView.isHidden = true
        fixedHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: fixedHeaderViewHeight)
        view.addSubview(fixedHeaderView)
        
        // Calculate the y position so the segmented control is at the bottom of the fixedHeaderView
        let segmentedControlHeight: CGFloat = 31 // Fixed height of the segmented control
        let yPosition = fixedHeaderViewHeight - segmentedControlHeight // Position at the bottom
        
        // Initialize the fixedSegmentedControl with the calculated y position
        fixedSegmentedControl = UnderlineSegmentedControl(items: ["등록한 맛집", "좋아한 맛집", "나의 후기"])
        fixedSegmentedControl.frame = CGRect(x: 10, y: yPosition, width: fixedHeaderView.frame.width - 20, height: segmentedControlHeight)
        fixedSegmentedControl.selectedSegmentIndex = MyPageSegment.selectedSegmentIndex
        fixedSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        fixedHeaderView.addSubview(fixedSegmentedControl)
    }


    
    // 세그먼트 컨트롤 설정 및 액션 추가
    private func setupSegmentedControl() {
        MyPageSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    // 세그먼트 컨트롤 값 변경 시 호출될 메서드
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        MyPageSegment.selectedSegmentIndex = selectedIndex
        fixedSegmentedControl.selectedSegmentIndex = selectedIndex
        switchToViewController(at: selectedIndex)
    }


    
    // 주어진 인덱스에 해당하는 뷰 컨트롤러로 전환
    private func switchToViewController(at index: Int) {
        guard index >= 0 && index < viewControllerIdentifiers.count else { return }
        let identifier = viewControllerIdentifiers[index]
        if let newViewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            // 이전 뷰 컨트롤러 제거
            removeCurrentViewController()
            
            // 새 뷰 컨트롤러를 자식으로 추가
            addChild(newViewController)
            containerView.addSubview(newViewController.view)
            newViewController.view.frame = containerView.bounds
            newViewController.didMove(toParent: self)
            
            // 현재 뷰 컨트롤러 업데이트
            currentViewController = newViewController
        }
    }
    
    // 현재 활성화된 뷰 컨트롤러 제거
    private func removeCurrentViewController() {
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset >= triggerOffset {
            // 스크롤이 triggerOffset 이상일 때 고정 헤더 뷰를 표시하고 상단에 고정
            fixedHeaderView.isHidden = false
            fixedHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: fixedHeaderViewHeight)
            view.bringSubviewToFront(fixedHeaderView) // 뷰 계층에서 가장 앞으로 가져옴
            scrollView.contentInset.top = fixedHeaderViewHeight // 고정 헤더 뷰 높이만큼 상단 인셋 조정
        } else {
            // 스크롤이 triggerOffset 미만일 때 고정 헤더 뷰 숨김
            fixedHeaderView.isHidden = true
            scrollView.contentInset.top = 0 // 상단 인셋 초기화
        }
    }
    
    @IBAction func goToDetail(_ sender: Any) {
        viewModel?.coordinator?.goToDetailMyPageView()
    }
    
    
}
