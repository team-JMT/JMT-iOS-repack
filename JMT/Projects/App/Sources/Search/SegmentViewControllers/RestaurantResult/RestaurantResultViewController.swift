//
//  RestaurantResultViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit

class RestaurantResultViewController: UIViewController {
    
    var viewModel: SearchViewModel?

    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantCollectionView.collectionViewLayout = createLayout()
        restaurantCollectionView.keyboardDismissMode = .onDrag
        
        let filterHeaderView = UINib(nibName: "RestaurantFilterHeaderView", bundle: nil)
        restaurantCollectionView.register(filterHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "filterHeader")
        
        let titleHeaderView = UINib(nibName: "RestaurantTitleHeaderView", bundle: nil)
        restaurantCollectionView.register(titleHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "title1Header")
        
        let title2HeaderView = UINib(nibName: "RestaurantTitle2HeaderView", bundle: nil)
        restaurantCollectionView.register(title2HeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "title2Header")
        
        let nib = UINib(nibName: "SearchResultEmptyCell", bundle: nil)
        restaurantCollectionView.register(nib, forCellWithReuseIdentifier: "SearchResultEmptyCell")
        
        let restaurantNib = UINib(nibName: "RestaurantInfoCell", bundle: nil)
        restaurantCollectionView.register(restaurantNib, forCellWithReuseIdentifier: "RestaurantInfoCell")
        
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                return self.createFirstColumnSection()
            case 1:
                return self.createFourthColumnSection()
            default:
                return nil
            }
        }
        
        layout.register(CollectionBackgroundViewInset.self, forDecorationViewOfKind: "BackgroundViewInset")
        return layout
    }
    
    func createFirstColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // .fractionalWidth(0.6675),
            heightDimension: .estimated(100) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 32, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        // Header
//        section.boundarySupplementaryItems = [
//            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(58)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]

        return section
    }
    
    func createSecondColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(211)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130), // .fractionalWidth(0.6675),
            heightDimension: .absolute(211) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 20, bottom: 32, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = CGFloat(8)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]

        return section
    }
    
    func createThirdColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // .fractionalWidth(0.6675),
            heightDimension: .estimated(100) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 32, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createFourthColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // .fractionalWidth(0.6675),
            heightDimension: .estimated(100) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        return section
    }
}

extension RestaurantResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if viewModel?.restaurants.isEmpty == true {
                return 1
            } else {
                return viewModel?.restaurants.count ?? 0
            }
           
        case 1:
            if viewModel?.outBoundrestaurants.isEmpty == true {
                return 1
            } else {
                return viewModel?.outBoundrestaurants.count ?? 0 > 3 ? 3 : viewModel?.outBoundrestaurants.count ?? 0
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if viewModel?.restaurants.isEmpty == true {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultEmptyCell", for: indexPath) as? SearchResultEmptyCell else { return UICollectionViewCell() }
                cell.setupCommentLabel(str: "맛집 목록은 그룹 멤버만 볼 수 있어요", isHideButton: true)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantInfoCell", for: indexPath) as? RestaurantInfoCell else { return UICollectionViewCell() }
                cell.setupRestaurantData(restaurantData: viewModel?.restaurants[indexPath.row])
                return cell
            }
        case 1:
            
            if viewModel?.outBoundrestaurants.isEmpty == true {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultEmptyCell", for: indexPath) as? SearchResultEmptyCell else { return UICollectionViewCell() }
                cell.setupCommentLabel(str: "다른 그룹에 등록된 맛집이 없어요", isHideButton: true)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantInfoCell", for: indexPath) as? RestaurantInfoCell else { return UICollectionViewCell() }
                cell.setupOutBoundrestaurantData(outBoundrestaurantData: viewModel?.outBoundrestaurants[indexPath.row])
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}

extension RestaurantResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "filterHeader", for: indexPath) as! RestaurantFilterHeaderView
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "title1Header", for: indexPath) as! RestaurantTitleHeaderView
                return header
            case 2:
                return UICollectionReusableView()
            case 3:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "title2Header", for: indexPath) as! RestaurantTitle2HeaderView
                return header
            default:
                return UICollectionReusableView()
            }
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
