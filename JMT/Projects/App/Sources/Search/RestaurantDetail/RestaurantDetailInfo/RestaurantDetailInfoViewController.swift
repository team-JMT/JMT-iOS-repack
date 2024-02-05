//
//  RestaurantDetailInfoViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

class RestaurantDetailInfoViewController: UIViewController {
    
    var viewModel: RestaurantDetailInfoViewModel?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoCollectionView.collectionViewLayout = createLayout()
        
        // 테스트 
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.infoCollectionView.reloadData()
            self.infoCollectionView.layoutIfNeeded()
            
            self.infoCollectionViewHeight.constant = self.infoCollectionView.collectionViewLayout.collectionViewContentSize.height
        }
        
        let restaurantDetailHeaderView = UINib(nibName: "RestaurantDetailTitleHeaderView", bundle: nil)
        infoCollectionView.register(restaurantDetailHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RestaurantDetailTitleHeaderView")
        let restaurantDetailFooterView = UINib(nibName: "RestaurantDetailFooterView", bundle: nil)
        infoCollectionView.register(restaurantDetailFooterView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RestaurantDetailFooterView")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = infoCollectionView.collectionViewLayout.collectionViewContentSize.height
       
        if infoCollectionViewHeight.constant != height && height != 0.0 {
            infoCollectionViewHeight.constant = height
            view.layoutIfNeeded()
        }
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
        
        layout.register(GrayBackgroundView.self, forDecorationViewOfKind: "GrayBackgroundView")
        layout.register(GrayBackgroundViewInset.self, forDecorationViewOfKind: "GrayBackgroundViewInset")
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
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundView")
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
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createReviewColumnSection() -> NSCollectionLayoutSection {
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
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createPhotosColumnSection() -> NSCollectionLayoutSection {
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 41, trailing: 20)

        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(41)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
}

extension RestaurantDetailInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.restorationIdentifier == "test1" {
            return 1
        } else {
            return 4
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "test1" {
            return 10
        } else if collectionView.restorationIdentifier == "test2" {
            switch section {
            case 0:
                return 5
            case 1:
                return 5
            case 2:
                return 2
            case 3:
                return 9
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "test1" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            return cell
        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoTagCell", for: indexPath) as? InfoTagCell else { return UICollectionViewCell() }
                cell.tagButton.setTitle(viewModel?.test1[indexPath.row], for: .normal)
                cell.sizeToFit()
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoTagCell", for: indexPath) as? InfoTagCell else { return UICollectionViewCell() }
                cell.tagButton.setTitle(viewModel?.test2[indexPath.row], for: .normal)
                cell.sizeToFit()
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
                cell.sizeToFit()
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
                cell.sizeToFit()
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
}

extension RestaurantDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView.restorationIdentifier == "test1" {
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
                return header
            default:
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
}


