//
//  RestaurantDetailViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import UIKit
import SnapKit

class RestaurantDetailViewController: UIViewController, KeyboardEvent {
    
    // MARK: - Properties
    var transformView: UIView { return self.view }
    
    var viewModel: RestaurantDetailViewModel?
    
    var pageViewController: RestaurantDetailPageViewController?
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var differenceInDistanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var pageContainerView: UIView!
    
    @IBOutlet weak var restanurantSegController: UISegmentedControl!
    
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
        
        setupData()
        
        imageViews = [reviewImageView1, reviewImageView2, reviewImageView3, reviewImageView4, reviewImageView5]
        
        pageViewController?.pageViewDelegate = self
        setCustomNavigationBarBackButton(isSearchVC: false)
        
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
        
        setupKeyboardEvent { noti in
            guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            self.bottomContainerStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.cgRectValue.height)
            
        } keyboardWillHide: { noti in
            self.bottomContainerStackView.transform = .identity
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        
        removeKeyboardObserver()
    }
    
    // MARK: - SetupBindings
    func setupBind() {
        viewModel?.didUpdateReviewImage = {
            self.reorderImageViews()
        }
    }
    
    // MARK: - SetupData
    func setupData() {
        print(viewModel?.restauranId)
    }
    
    
    // MARK: - SetupUI
    func setupUI() {
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: JMTengAsset.gray300.color // 일반 상태에서의 텍스트 색상
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 14),
            .foregroundColor: JMTengAsset.main500.color // 선택된 상태에서의 텍스트 색상
        ]
        
        restanurantSegController.setTitleTextAttributes(normalTextAttributes, for: .normal)
        restanurantSegController.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        if let pageVC = pageViewController {
            self.addChild(pageVC)
            pageContainerView.addSubview(pageVC.view)
            pageVC.didMove(toParent: self)
            
            pageVC.view.snp.makeConstraints { make in
                make.leading.trailing.top.bottom.equalToSuperview()
            }
        }
        
        reviewTextView.alignTextVerticallyInContainer()
        
        addReviewImageButton.layer.cornerRadius = 8
        addReviewImageButton.layer.borderColor = JMTengAsset.main500.color.cgColor
        addReviewImageButton.layer.borderWidth = 1
        
        doneReviewButton.layer.cornerRadius = 8
        
        reviewTextView.layer.cornerRadius = 8
        reviewTextView.layer.borderColor = JMTengAsset.gray300.color.cgColor
        reviewTextView.layer.borderWidth = 1
        
        //        placeNameLabel.text = viewModel?.restaurantInfo?.name ?? ""
        //        differenceInDistanceLabel.text = "위치에서 \(viewModel?.restaurantInfo?.differenceInDistance ?? "")"
        //        categoryLabel.text = viewModel?.restaurantInfo?.category ?? ""
        //        addressLabel.text = viewModel?.restaurantInfo?.address ?? ""
        //
        //        userNicknameLabel.text = viewModel?.restaurantInfo?.userNickName ?? ""
    }
    
    // MARK: - Actions
    @IBAction func didTabSegmentedController(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = viewModel?.currentSegIndex ?? 0 <= index ? .forward : .reverse
        
        if let pageVC = pageViewController {
            pageVC.setViewControllers([pageVC.vcArray[index]], direction: direction, animated: true)
            viewModel?.currentSegIndex = index
        }
    }
    
    @IBAction func didTabAddPhotoButton(_ sender: Any) {
        
        viewModel?.coordinator?.showImagePicker()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        guard viewModel?.reviewImages.count ?? 0 > tappedImageView.tag else { return }
        
        viewModel?.reviewImages.remove(at: tappedImageView.tag)
        
        // 남은 이미지로 이미지뷰 재정렬
        reorderImageViews()
    }
    
    // MARK: - Helper Methods
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
        restanurantSegController.selectedSegmentIndex = index
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

