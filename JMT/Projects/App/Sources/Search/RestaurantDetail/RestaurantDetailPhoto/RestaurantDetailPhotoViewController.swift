//
//  RestaurantDetailPhotoViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

class RestaurantDetailPhotoViewController: UIViewController {

    weak var viewModel: RestaurantDetailViewModel?
    weak var delegate: RestaurantDetailViewControllerDelegate?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    private var oldContentOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
        
            switch sectionIndex {
            case 0:
                return self.createPhotosColumnSection()
            default:
                return nil
            }
        }
        
        layout.register(CollectionBackgroundView.self, forDecorationViewOfKind: "BackgroundView")
        layout.register(CollectionBackgroundViewInset.self, forDecorationViewOfKind: "BackgroundViewInset")
        return layout
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
            
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
}

extension RestaurantDetailPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
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

extension RestaurantDetailPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.restaurantReviewImages.count == 0 ? 1 : viewModel?.restaurantReviewImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel?.restaurantReviewImages.count == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as? RestaurantEmptyPhotoCell else { return UICollectionViewCell() }
            cell.setupData(comment: "아직 등록된 사진이 없어요")
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewPhotoCell", for: indexPath) as? RestaurantReviewPhoto2Cell else { return UICollectionViewCell() }
            cell.setupData(imageUrl: viewModel?.restaurantReviewImages[indexPath.row] ?? "")
            return cell
        }
    }
}

extension RestaurantDetailPhotoViewController: UIScrollViewDelegate {
    
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
