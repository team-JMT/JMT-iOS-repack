//
//  RestaurantDetailViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit
import SnapKit
import Kingfisher
import Toast_Swift
import FloatingPanel
import Then

protocol RestaurantDetailViewControllerDelegate: AnyObject {
    var headerHeight: CGFloat { get }
    func didScroll(y: CGFloat)
}

class RestaurantDetailViewController: UIViewController, KeyboardEvent {
   
    deinit {
        print("RestaurantDetailViewController Deinit")
    }
    
    // MARK: - Properties
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
    
    @IBOutlet weak var reviewContainerView: UIView!
    @IBOutlet weak var reviewContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reviewPhotoCollectionView: UICollectionView!
    
    @IBOutlet weak var addReviewPhotosButton: UIButton!
    @IBOutlet weak var doneReviewButton: UIButton!
    
    var navigationTitleLabel = UILabel().then {
        $0.alpha = 0
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    var transformView: UIView { return self.view }
    
    var viewModel: RestaurantDetailViewModel?
    
    var pageViewController: RestaurantDetailPageViewController?
    var moreMenuFpc: FloatingPanelController!
    
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
                
                viewModel?.didUpdateRestaurantSeg?()
                
                self.setupData()                
            } catch {
                print(error)
            }
        }

        pageViewController?.pageViewDelegate = self
        pageViewController?.restaurantDetailDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    
        setCustomNavigationMoreButton()
        
        if viewModel?.coordinator?.parentCoordinator is DefaultHomeCoordinator {
            setCustomNavigationBarBackButton(goToViewController: .popVC)
        } else if viewModel?.coordinator?.parentCoordinator is DefaultRegistrationRestaurantInfoCoordinator {
            setCustomNavigationBarBackButton(goToViewController: .popToRootVC)
        } else if viewModel?.coordinator?.parentCoordinator is DefaultSearchCoordinator {
            setCustomNavigationBarBackButton(goToViewController: .popVC)
        } else if viewModel?.coordinator?.parentCoordinator is DefaultMyPageCoordinator {
            setCustomNavigationBarBackButton(goToViewController: .popVC)
        }
        
        setupKeyboardEvent { [weak self] noti in
            guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            self?.reviewContainerView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
        
        } keyboardWillHide: { [weak self] noti in
            self?.reviewContainerView.transform = .identity
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        removeKeyboardObserver()
    }

    // MARK: - FetchData
   
    
    // MARK: - SetupBindings
    func setupBind() {
        viewModel?.didUpdateSelectedReviewImage = { [weak self] in
            guard let self = self else { return }
            self.reviewPhotoCollectionView.reloadData()
        }
        
        viewModel?.didUpdateSeg = { [weak self] index in
            guard let self = self else { return }
            changePage(to: index)
            restaurantInfoSegController.selectedSegmentIndex = index
        }
        
        viewModel?.onScrollBeginDismissKeyboard = { [weak self] in
            guard let self = self else { return }
            self.reviewTextView.resignFirstResponder()
        }
    }
    
    // MARK: - SetupData
    func setupData() {
        
        placeNameLabel.text = viewModel?.restaurantData?.name ?? ""
       
        if viewModel?.locationManager.coordinate == nil {
            differenceInDistanceLabel.text = "알 수 없음"
        } else {
            differenceInDistanceLabel.text = "위치에서 \((Int(viewModel?.restaurantData?.differenceInDistance ?? "") ?? 0).distanceWithUnit())"
        }
        
        categoryLabel.text = viewModel?.restaurantData?.category ?? ""
        addressLabel.text = viewModel?.restaurantData?.address ?? ""
        
        if let imageUrl = URL(string: viewModel?.restaurantData?.userProfileImageUrl ?? "") {
            userProfileImageView.kf.setImage(with: imageUrl)
        } else {
            userProfileImageView.image = JMTengAsset.defaultProfileImage.image
        }
        
        userNicknameLabel.text = viewModel?.restaurantData?.userNickName ?? ""
        
        navigationTitleLabel.text = viewModel?.restaurantData?.name ?? ""
    }
    
    
    // MARK: - SetupUI
    func setupUI() {
        
        configNavigationTitleView()
    
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
        
        
        reviewTextView.text = "방문 후기를 작성해보세요!"
        reviewTextView.textColor = UIColor.lightGray
        
        reviewTextView.textContainerInset = .zero
        reviewTextView.textContainer.lineFragmentPadding = 0
        reviewTextView.alignTextVerticallyInContainer()
        
        doneReviewButton.layer.cornerRadius = 6
    }
    
    func configNavigationTitleView() {
        let totalWidth = self.navigationController?.navigationBar.frame.width ?? 0
        let leftItemWidth = self.navigationItem.leftBarButtonItem?.customView?.frame.width ?? 0
        let rightItemWidth = self.navigationItem.rightBarButtonItem?.customView?.frame.width ?? 0
        let availableWidth = totalWidth - leftItemWidth - rightItemWidth - 32 // 좌우 여백 고려
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 44))
        titleView.backgroundColor = .clear
        
        navigationTitleLabel.frame = titleView.bounds
        titleView.addSubview(navigationTitleLabel)
        
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        // 네비게이션 바에 titleView 설정
        self.navigationItem.titleView = titleView
    }
    
    func showMoreMenuBottomSheetViewController() {
        
        let storyboard = UIStoryboard(name: "RestaurantMoreMenu", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "RestaurantMoreMenuViewController") as? RestaurantMoreMenuViewController else { return }
    
        vc.viewModel = self.viewModel
        
        moreMenuFpc = FloatingPanelController(delegate: self)
        moreMenuFpc.set(contentViewController: vc)
        moreMenuFpc.layout = RestaurantMoreMenuBottomSheetFloatingPanelLayout()
        moreMenuFpc.panGestureRecognizer.isEnabled = false
        moreMenuFpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        moreMenuFpc.setPanelStyle(radius: 24, isHidden: true)
        
        self.present(moreMenuFpc, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func didTabSegmentedController(_ sender: UISegmentedControl) {
        changePage(to: sender.selectedSegmentIndex)
    }
    
    @IBAction func didTabAddPhotoButton(_ sender: Any) {
        viewModel?.coordinator?.showImagePicker()
    }
    
    @IBAction func didTabAddReviewButton(_ sender: Any) {
        
        Task {
            do {
                try await viewModel?.registrationReview(content: reviewTextView.text ?? "")
                try await viewModel?.fetchRestaurantReviewData()
                
                viewModel?.didUpdateRestaurantSeg?()
                viewModel?.didUpdatePhotoSeg?()
                viewModel?.didUpdateReviewSeg?()
                
                reviewTextView.text = "방문 후기를 작성해보세요!"
                reviewTextView.textColor = UIColor.lightGray
                
                viewModel?.reviewImages.removeAll()
                reviewPhotoCollectionView.reloadData()
                
                showCustomToast(image: JMTengAsset.checkMark.image, message: "후기 등록이 완료되었어요!", padding: 117, position: .bottom)
                
                let appCoordinator = viewModel?.coordinator?.getTopCoordinator()
                appCoordinator?.updateAllRestaurantsData()
                
            } catch {
                print(error)
            }
        }
    }
    
    
    @IBAction func didTabCopyAddressButton(_ sender: Any) {
        UIPasteboard.general.string = addressLabel.text
        showCustomToast(image: JMTengAsset.checkMark.image, message: "주소 복사가 완료되었어요!", padding: 117, position: .bottom)
    }
    
    // MARK: - Helper Methods
    func changePage(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = viewModel?.currentSegIndex ?? 0 <= index ? .forward : .reverse
        
        if let pageVC = pageViewController {
            pageVC.setViewControllers([pageVC.vcArray[index]], direction: direction, animated: true)
            viewModel?.currentSegIndex = index
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reviewTextView.resignFirstResponder()
    }
}

// MARK: - Extention
extension RestaurantDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.reviewImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewPhotoCell", for: indexPath) as? ReviewPhotoCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.setupReviewPhoto(image: viewModel?.reviewImages[indexPath.row] ?? UIImage())
        return cell
    }
}

extension RestaurantDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀의 너비와 높이를 설정합니다.
        let cellWidth = 44 // 예시 너비
        let cellHeight = 44 // 예시 높이
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension RestaurantDetailViewController: RestaurantDetailPageViewControllerDelegate {
    func updateSegmentIndex(index: Int) {
        restaurantInfoSegController.selectedSegmentIndex = index
    }
}

extension RestaurantDetailViewController: ReviewPhotoCellDelegate {
    func didTabDeleteButton(in cell: UICollectionViewCell) {
        guard let indexPath = reviewPhotoCollectionView.indexPath(for: cell) else { return  }
        
        viewModel?.reviewImages.remove(at: indexPath.item)
        
        reviewPhotoCollectionView.performBatchUpdates {
            reviewPhotoCollectionView.deleteItems(at: [indexPath])
        }
    }
}


extension RestaurantDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = 42.0 // 2줄일 때의 최대 높이
        let minHeight: CGFloat = 21.0 // 1줄일 때의 최소 높이
        
        if textView.numberOfLines == 1 {
            // 라인 수가 2줄 이하일 때, 높이를 42로 고정합니다.
            reviewTextViewHeight.constant = minHeight
        } else if textView.numberOfLines == 2 {
            // 라인 수가 2줄을 초과할 때는 스크롤을 허용하거나 다른 로직을 적용합니다.
            reviewTextViewHeight.constant = maxHeight
        } else {
            return
        }
        
        // 감싸고 있는 뷰의 높이를 조절합니다.
        let extraSpace = 107.0 - 21.0 // 텍스트뷰 외의 추가 공간을 계산합니다.
        reviewContainerViewHeight.constant = reviewTextViewHeight.constant + extraSpace
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded() // 레이아웃을 애니메이션과 함께 업데이트합니다.
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "방문 후기를 작성해보세요!" {
            textView.text = "" // 텍스트를 비웁니다.
            textView.textColor = UIColor.black // 입력 텍스트 색상을 변경합니다.
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "방문 후기를 작성해보세요!" // 기본 가이드 메시지를 표시합니다.
            textView.textColor = UIColor.lightGray // 가이드 메시지 색상을 변경합니다.
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
        
        navigationTitleLabel.alpha = percentage
    }
}

extension RestaurantDetailViewController: FloatingPanelControllerDelegate {
    
}

extension RestaurantDetailViewController: ButtonPopupDelegate {
    func didTabDoneButton() {
        Task {
            do {
                try await self.viewModel?.deleteRestaurant()
                let rootCoordinator = viewModel?.coordinator?.getTopCoordinator()
                rootCoordinator?.updateAllRestaurantsData()
                
                self.navigationController?.popViewController(animated: true)
                self.showCustomToast(image: JMTengAsset.checkMark.image, message: "삭제가 완료되었어요!", padding: 117, position: .bottom)
            } catch {
                print(error)
                self.showCustomToast(image: JMTengAsset.notCheckMark.image, message: "맛집을 삭제하지 못했어요!", padding: 117, position: .bottom)
            }
        }
    }
    
    func didTabCloseButton() { }
    
    func didTabCancelButton() { }
}
