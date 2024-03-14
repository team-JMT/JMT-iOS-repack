//
//  RestaurantDetailViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit
import SnapKit
import Kingfisher

protocol RestaurantDetailViewControllerDelegate: AnyObject {
    var headerHeight: CGFloat { get }
    func didScroll(y: CGFloat)
}

class RestaurantDetailViewController: UIViewController, KeyboardEvent {
   
    deinit {
        print("RestaurantDetailViewController Deinit")
    }
    
    // MARK: - Properties
    var transformView: UIView { return self.view }
    
    var viewModel: RestaurantDetailViewModel?
    
    var pageViewController: RestaurantDetailPageViewController?
    
    @IBOutlet weak var restaurantInfoView: UIView!
    @IBOutlet weak var restaurantInfoViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var differenceInDistanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var restaurantInfoViewTop: NSLayoutConstraint!
    @IBOutlet weak var pageContainerViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var restaurantInfoSegController: UISegmentedControl!
    
    @IBOutlet weak var photosContainerView: UIView!
    
    @IBOutlet weak var reviewImageView1: UIImageView!
    @IBOutlet weak var reviewImageView2: UIImageView!
    @IBOutlet weak var reviewImageView3: UIImageView!
    @IBOutlet weak var reviewImageView4: UIImageView!
    @IBOutlet weak var reviewImageView5: UIImageView!
    
    @IBOutlet weak var bottomContainerStackView: UIStackView!
    @IBOutlet weak var addReviewImageButton: UIButton!
    @IBOutlet weak var doneReviewButton: UIButton!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewTextViewHeightConstraint: NSLayoutConstraint!
    
    var imageViews = [UIImageView]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBind()
        
        Task {
            do {
                await viewModel?.fetchCurrentLocationAsync()
                try await viewModel?.fetchRestaurantData()
                try await viewModel?.fetchRestaurantReviewData()
                
                self.setupData()
                            
                self.viewModel?.didCompletedRestaurant?()
                
            } catch {
                print(error)
            }
        }
        

        pageViewController?.pageViewDelegate = self
        pageViewController?.restaurantDetailDelegate = self
        
        imageViews = [reviewImageView1, reviewImageView2, reviewImageView3, reviewImageView4, reviewImageView5]
        // 각 이미지뷰에 제스처 추가
        for (index, imageView) in imageViews.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
            imageView.tag = index // 태그를 사용하여 각 이미지뷰 식별
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        if viewModel?.coordinator?.parentCoordinator is DefaultHomeCoordinator {
            setCustomNavigationBarBackButton(goToViewController: .popVC)
        } else if viewModel?.coordinator?.parentCoordinator is DefaultRegistrationRestaurantInfoCoordinator {
            setCustomNavigationBarBackButton(goToViewController: .popToRootVC)
        }
        
        setupKeyboardEvent { [weak self] noti in
            guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            self?.bottomContainerStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
            
            print(-keyboardFrame.cgRectValue.height)
            
        } keyboardWillHide: { [weak self] noti in
            self?.bottomContainerStackView.transform = .identity
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    
        removeKeyboardObserver()
        viewModel?.coordinator?.parentCoordinator?.finish()
    }
    // MARK: - FetchData
   
    
    // MARK: - SetupBindings
    func setupBind() {
        viewModel?.didUpdateReviewImage = { [weak self] in
            guard let self = self else { return }
            self.reorderImageViews()
        }
        
        viewModel?.didUpdateSeg = { [weak self] index in
            guard let self = self else { return }
            changePage(to: index)
            restaurantInfoSegController.selectedSegmentIndex = index
        }
    }
    
    // MARK: - SetupData
    func setupData() {
        placeNameLabel.text = viewModel?.restaurantData?.name ?? ""
       
        if viewModel?.locationManager.coordinate == nil {
            differenceInDistanceLabel.text = "알 수 없음"
        } else {
            differenceInDistanceLabel.text = "위치에서 \(viewModel?.restaurantData?.differenceInDistance ?? "")m"
        }
        
        categoryLabel.text = viewModel?.restaurantData?.category ?? ""
        addressLabel.text = viewModel?.restaurantData?.address ?? ""
        
        if let imageUrl = URL(string: viewModel?.restaurantData?.userProfileImageUrl ?? "") {
            userProfileImageView.kf.setImage(with: imageUrl)
        } else {
            userProfileImageView.image = JMTengAsset.defaultProfileImage.image
        }
        
        userNicknameLabel.text = viewModel?.restaurantData?.userNickName ?? ""
        
        self.navigationController?.setupBarAppearance(alpha: 0)
        self.navigationItem.title = viewModel?.restaurantData?.name ?? ""
    }
    
    
    // MARK: - SetupUI
    func setupUI() {
    
        // 세그먼트 컨트롤러 설정
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: JMTengAsset.gray300.color // 일반 상태에서의 텍스트 색상
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: JMTengAsset.main500.color // 선택된 상태에서의 텍스트 색상
        ]
        
        restaurantInfoSegController.setTitleTextAttributes(normalTextAttributes, for: .normal)
        restaurantInfoSegController.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        // 페이지 뷰 컨트롤러 설정
        if let pageVC = pageViewController {
            self.addChild(pageVC)
            pageContainerView.addSubview(pageVC.view)
            pageVC.didMove(toParent: self)
            
            pageVC.view.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
        
        // 닉네임 이미지 성정
        userProfileImageView.layer.cornerRadius = 10
        
        // 후기 입력 뷰 설정
        reviewTextView.alignTextVerticallyInContainer()
        
        addReviewImageButton.layer.cornerRadius = 8
        addReviewImageButton.layer.borderColor = JMTengAsset.main500.color.cgColor
        addReviewImageButton.layer.borderWidth = 1
        
        doneReviewButton.layer.cornerRadius = 8
        
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.layer.borderColor = JMTengAsset.gray300.color.cgColor
        reviewTextView.layer.borderWidth = 1
    }
    
    // MARK: - Actions
    @IBAction func didTabSegmentedController(_ sender: UISegmentedControl) {
        changePage(to: sender.selectedSegmentIndex)
    }
    
    @IBAction func didTabAddPhotoButton(_ sender: Any) {
        viewModel?.coordinator?.showImagePicker()
    }
    
    @IBAction func didTabAddReviewButton(_ sender: Any) {
       
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        guard viewModel?.reviewImages.count ?? 0 > tappedImageView.tag else { return }
        
        viewModel?.reviewImages.remove(at: tappedImageView.tag)
        
        // 남은 이미지로 이미지뷰 재정렬
        reorderImageViews()
    }
    
    // MARK: - Helper Methods
    func changePage(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = viewModel?.currentSegIndex ?? 0 <= index ? .forward : .reverse
        
        if let pageVC = pageViewController {
            pageVC.setViewControllers([pageVC.vcArray[index]], direction: direction, animated: true)
            viewModel?.currentSegIndex = index
        }
    }
    
    func reorderImageViews() {
        photosContainerView.isHidden = viewModel?.reviewImages.isEmpty == true ? true : false
        // 모든 이미지뷰 초기화
        imageViews.forEach { $0.image = nil }
        
        // 이미지를 다시 이미지뷰에 할당
        for (index, image) in (viewModel?.reviewImages ?? []).enumerated() {
            imageViews[index].image = image
        }
    }
}

// MARK: - Extention
extension RestaurantDetailViewController: RestaurantDetailPageViewControllerDelegate {
    func updateSegmentIndex(index: Int) {
        restaurantInfoSegController.selectedSegmentIndex = index
    }
}

extension RestaurantDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        let contentHeight = textView.contentSize.height
    
        if contentHeight <= 100 {
            reviewTextViewHeightConstraint.constant = contentHeight + 8.5 + 8.5 // 상하 여백 포함
            textView.centerVertically() // 수직 가운데 정렬
            textView.layoutIfNeeded() // 레이아웃 즉시 업데이트
        }
    }
}

extension RestaurantDetailViewController: RestaurantDetailViewControllerDelegate {
    var headerHeight: CGFloat {
        return restaurantInfoViewHeight.constant
    }
    
    func didScroll(y: CGFloat) {
    
        restaurantInfoViewHeight.constant -= y
        
        if restaurantInfoViewHeight.constant > viewModel?.stickyHeaderViewConfig.initialHeight ?? 0.0 {
            restaurantInfoViewHeight.constant = viewModel?.stickyHeaderViewConfig.initialHeight ?? 0.0
        }

        if restaurantInfoViewHeight.constant < viewModel?.stickyHeaderViewConfig.finalHeight ?? 0.0 {
            restaurantInfoViewHeight.constant = viewModel?.stickyHeaderViewConfig.finalHeight ?? 0.0
        }
  
        let percentage = 1 - restaurantInfoViewHeight.constant / 200
        self.navigationController?.setupBarAppearance(alpha: percentage)
    }
}
