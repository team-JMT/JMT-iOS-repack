//
//  RestaurantDetailReviewViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

class RestaurantDetailReviewViewController: UIViewController {

    weak var viewModel: RestaurantDetailViewModel?
    weak var delegate: RestaurantDetailViewControllerDelegate?
    
    private var oldContentOffset = CGPoint.zero
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewCollectionView.collectionViewLayout = createLayout()
        reviewCollectionView.keyboardDismissMode = .onDrag
    
        setupBind()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createReviewColumnSection()
            default:
                return nil
            }
        }
    }
    
    func createReviewColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 41 + 56, trailing: 20)
        section.interGroupSpacing = 16
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(22)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        return section
    }
    
    func setupBind() {
        viewModel?.didupdateReviewData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.reviewCollectionView.reloadData()
            }
        }
    }
}

extension RestaurantDetailReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.restaurantData?.reviews.count == 0 ? 1 : viewModel?.restaurantData?.reviews.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel?.restaurantData?.reviews.count == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? RestaurantEmptyReviewCell else { return UICollectionViewCell() }
            cell.setupData(comment: "아직 등록된 후기가 없어요")
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? RestaurantReview2Cell else { return UICollectionViewCell() }
            cell.setupData(reviewData: viewModel?.restaurantData?.reviews[indexPath.row])
            return cell
        }
    }
}

extension RestaurantDetailReviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}


extension RestaurantDetailReviewViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel?.onScrollBeginDismissKeyboard?()
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
