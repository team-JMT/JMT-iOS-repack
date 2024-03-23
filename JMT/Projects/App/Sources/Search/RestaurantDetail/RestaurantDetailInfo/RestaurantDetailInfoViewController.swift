//
//  RestaurantDetailInfoViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

class RestaurantDetailInfoViewController: UIViewController {
    
    // MARK: - Properties
    weak var viewModel: RestaurantDetailViewModel?
    weak var delegate: RestaurantDetailViewControllerDelegate?
    
    private var oldContentOffset = CGPoint.zero
    
    var currentPhotoPage: Int = 1
    
    @IBOutlet weak var rootScrollView: UIScrollView!
    @IBOutlet weak var photoCollectionContainerView: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionViewHeight: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        infoCollectionView.collectionViewLayout = createLayout()
        rootScrollView.keyboardDismissMode = .onDrag
        
        let restaurantDetailHeaderView = UINib(nibName: "RestaurantDetailTitleHeaderView", bundle: nil)
        infoCollectionView.register(restaurantDetailHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RestaurantDetailTitleHeaderView")
        let restaurantDetailFooterView = UINib(nibName: "RestaurantDetailFooterView", bundle: nil)
        infoCollectionView.register(restaurantDetailFooterView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RestaurantDetailFooterView")
    
        setupBind()      
    }
    
    // MARK: - SetupBindings
    func setupBind() {
        viewModel?.didCompletedRestaurant = {
            DispatchQueue.main.async {
                
                self.updatePhotoCount()
                
                self.photoCollectionView.reloadData()
                self.infoCollectionView.reloadData()
                
                self.infoCollectionView.layoutIfNeeded()
                self.infoCollectionViewHeight.constant = self.infoCollectionView.contentSize.height
            }
        }
        
        viewModel?.didupdateReviewData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.infoCollectionView.reloadData()
                
                self.infoCollectionView.layoutIfNeeded()
                self.infoCollectionViewHeight.constant = self.infoCollectionView.contentSize.height
            }
        }
    }
    
    // MARK: - FetchData
    
    // MARK: - SetupData
    func updatePhotoCount() {
        photoCountLabel.text = "\(self.currentPhotoPage) / 10"
        
        // 페이지 컨트롤 설정
        pageControl.numberOfPages = viewModel?.restaurantData?.pictures.count ?? 0
        pageControl.currentPage = 0
    }
    
    // MARK: - SetupUI
    func setupUI() {
        photoCollectionView.layer.cornerRadius = 8
    }
    
    @IBAction func didTabPageControl(_ sender: Any) {
        guard let pageControl = sender as? UIPageControl else { return }
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        currentPhotoPage = pageControl.currentPage
        photoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        photoCountLabel.text = "\(self.currentPhotoPage + 1) / 10"
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
        
            switch sectionIndex {
            case 0:
                return self.createTag1ColumnSection()
            case 1:
                return self.createTag2ColumnSection()
            case 2:
                return self.createReviewColumnSection()
            case 3:
                return self.createPhotosColumnSection()
            default:
                return nil
            }
        }
        
        layout.register(CollectionBackgroundView.self, forDecorationViewOfKind: "BackgroundView")
        layout.register(CollectionBackgroundViewInset.self, forDecorationViewOfKind: "BackgroundViewInset")
        return layout
    }
    
    func createTag1ColumnSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .absolute(33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createTag2ColumnSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .absolute(33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 36, trailing: 20)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createReviewColumnSection() -> NSCollectionLayoutSection {
        
        if viewModel?.restaurantData?.reviews.count == 0 {
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 28, trailing: 20)
            
            // Header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            ]
            
            // Background
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
            section.decorationItems = [sectionBackgroundDecoration]
            
            return section
        } else {
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 24, trailing: 20)
            section.interGroupSpacing = 16
            
            // Header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(61)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            ]
            
            // Background
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
            section.decorationItems = [sectionBackgroundDecoration]
            
            return section
        }
    }
    
    func createPhotosColumnSection() -> NSCollectionLayoutSection {
    
        if viewModel?.restaurantReviewImages.count == 0 {
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 20, trailing: 20)
            
            // Header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            ]
            
            // Background
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundView")
            section.decorationItems = [sectionBackgroundDecoration]
            
            return section
        } else {
            let fraction: CGFloat = 1 / 3
                
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
          
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 41 + 56, trailing: 20)

            // Header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            ]
            
            // Background
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundView")
            section.decorationItems = [sectionBackgroundDecoration]
            
            return section
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Helper Methods
    
    // MARK: - TableView Delegate
    
    // MARK: - TableView DataSource
    
    // MARK: - CollectionView Delegate
    
    // MARK: - CollectionView DataSource
    
    // MARK: - Extention
}

extension RestaurantDetailInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.restorationIdentifier == "photoCollectionView" {
            return 1
        } else {
            return 4
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "photoCollectionView" {
            return viewModel?.restaurantData?.pictures.count ?? 0
        } else if collectionView.restorationIdentifier == "test2" {
            switch section {
            case 0:
                return viewModel?.restaurantData?.recommendMenu.count ?? 0 // 메뉴 개수
            case 1:
                return viewModel?.restaurantData?.goWellWithLiquor == "" ? 0 : 1 // 술 개수
            case 2:
                return viewModel?.restaurantData?.reviews.isEmpty == true ? 1 : viewModel?.restaurantData?.reviews.count ?? 0 >= 2 ? 2 : 1
            case 3:
                return viewModel?.restaurantReviewImages.isEmpty == true ? 1: viewModel?.restaurantReviewImages.count ?? 0 >= 9 ? 9 : viewModel?.restaurantReviewImages.count ?? 0 // 사진 개수
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "photoCollectionView" {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantPhotoCell", for: indexPath) as? RestaurantPhotoCell else { return UICollectionViewCell() }
            cell.setupData(imageUrl: viewModel?.restaurantData?.pictures[indexPath.row] ?? "")
            return cell
        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoTagCell", for: indexPath) as? InfoTagCell else { return UICollectionViewCell() }
                cell.setupData(str: viewModel?.restaurantData?.recommendMenu[indexPath.row] ?? "")
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoTagCell", for: indexPath) as? InfoTagCell else { return UICollectionViewCell() }
                cell.setupData(str: viewModel?.restaurantData?.goWellWithLiquor ?? "")
                return cell
            case 2:
                if viewModel?.restaurantData?.reviews.isEmpty == true {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? RestaurantPhotnAndReviewEmptyCell else { return UICollectionViewCell() }
                    cell.setupUI(text: "아직 등록된 후기가 없어요")
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? RestaurantReview1Cell else { return UICollectionViewCell() }
                    cell.setupData(reviewData: viewModel?.restaurantData?.reviews[indexPath.row])
                    return cell
                }
            case 3:
                if viewModel?.restaurantReviewImages.isEmpty == true {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? RestaurantPhotnAndReviewEmptyCell else { return UICollectionViewCell() }
                    cell.setupUI(text: "아직 등록된 사진이 없어요")
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewImageCell", for: indexPath) as? RestaurantReviewPhoto1Cell else { return UICollectionViewCell() }
                    cell.setupData(imageUrl: viewModel?.restaurantReviewImages[indexPath.row] ?? "")
                    return cell
                }
            default:
                return UICollectionViewCell()
            }
            
        }
    }
}

extension RestaurantDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView.restorationIdentifier == "photoCollectionView" {
            return CGSize(width: self.view.frame.width - 40, height: self.view.frame.width - 40)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
}

extension RestaurantDetailInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailTitleHeaderView", for: indexPath) as! RestaurantDetailTitleHeaderView
                header.titleLabel.text = "메인메뉴"
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailTitleHeaderView", for: indexPath) as! RestaurantDetailTitleHeaderView
                header.titleLabel.text = "술과 함께 즐길 수 있어요 🍻"
                return header
            case 2:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailTitleHeaderView", for: indexPath) as! RestaurantDetailTitleHeaderView
                header.titleLabel.text = "멤버의 추천 한마디 ✍️"
                return header
            case 3:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailTitleHeaderView", for: indexPath) as! RestaurantDetailTitleHeaderView
                header.titleLabel.text = "맛집 사진"
                return header
            default:
                return UICollectionReusableView()
            }
        case UICollectionView.elementKindSectionFooter:
            switch indexPath.section {
            case 2:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailFooterView", for: indexPath) as! RestaurantDetailFooterView
                header.delegate = self
                return header
            default:
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
}

extension RestaurantDetailInfoViewController: RestaurantDetailFooterViewDelegate {
    func goToReviewTap() {
        viewModel?.didUpdateSeg?(2)
    }
}

extension RestaurantDetailInfoViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel?.onScrollBeginDismissKeyboard?()
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: photoCollectionView.contentOffset, size: photoCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = photoCollectionView.indexPathForItem(at: visiblePoint) {
            photoCountLabel.text = "\(visibleIndexPath.row + 1) / 10"
            pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y - oldContentOffset.y
        
        let stikcyHeaderViewHeightConstant = delegate?.headerHeight
        
        if let stikcyHeaderViewHeightConstant = stikcyHeaderViewHeightConstant {
            
            // offsetY가 0 보다 클때 (위로 스크롤)
            // offsetY = offset과 oldOffset 뺀값
            // topViewHeightConstraintRange.lowerBound = 0
            // scrollView.contentOffset.y = 현재 offsetY값
            if offsetY > 0, stikcyHeaderViewHeightConstant > viewModel!.stickyHeaderViewConfig.heightConstraintRange.lowerBound, scrollView.contentOffset.y > 0 {
                delegate?.didScroll(y: offsetY)
                scrollView.contentOffset.y -= offsetY
            }

            // offsetY가 0 보다 클때 (아래로 스크롤)
            if offsetY < 0, stikcyHeaderViewHeightConstant < viewModel!.stickyHeaderViewConfig.heightConstraintRange.upperBound, scrollView.contentOffset.y < 0 {
                delegate?.didScroll(y: offsetY)
                scrollView.contentOffset.y -= offsetY
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
}


