//
//  TotalResultViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit

class TotalResultViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    
    @IBOutlet weak var totalResultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        totalResultCollectionView.collectionViewLayout = createLayout()
        totalResultCollectionView.keyboardDismissMode = .onDrag
        
        let header1 = UINib(nibName: "TitleHeaderView", bundle: nil)
        totalResultCollectionView.register(header1, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "titleHeaderView")
        let differentGroupHeader = UINib(nibName: "DifferentGroupHeader", bundle: nil)
        totalResultCollectionView.register(differentGroupHeader, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DifferentGroupHeader")
        
        let emptyNib = UINib(nibName: "SearchResultEmptyCell", bundle: nil)
        totalResultCollectionView.register(emptyNib, forCellWithReuseIdentifier: "SearchResultEmptyCell")
        
        let groupInfoNib = UINib(nibName: "GroupInfoCell", bundle: nil)
        totalResultCollectionView.register(groupInfoNib, forCellWithReuseIdentifier: "GroupInfoCell")
        
        let restaurantNib = UINib(nibName: "RestaurantInfoCell", bundle: nil)
        totalResultCollectionView.register(restaurantNib, forCellWithReuseIdentifier: "RestaurantInfoCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdate), name: .didUpdateGroup, object: nil)
    }
    
    @objc func handleDataUpdate() {
        DispatchQueue.main.async {
            self.totalResultCollectionView.reloadData()
        }
    }
    
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                return self.createFirstColumnSection()
            case 1:
                return self.createSecondColumnSection()
            case 2:
                return self.createThirdColumnSection()
            default:
                return nil
            }
        }
        
        layout.register(CollectionBackgroundViewInset.self, forDecorationViewOfKind: "BackgroundViewInset")
        return layout
    }
    
    func createFirstColumnSection() -> NSCollectionLayoutSection {
        if viewModel?.restaurants.isEmpty == true {
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 52, trailing: 20)
            section.interGroupSpacing = CGFloat(12)
            
            // Header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            ]
            
            // Background
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
            section.decorationItems = [sectionBackgroundDecoration]

            return section
        } else {
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
          
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), // .fractionalWidth(0.6675),
                heightDimension: .absolute(100) // .fractionalHeight(0.4215)
            )
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 52, trailing: 20)
            section.interGroupSpacing = CGFloat(12)
            
            // Header
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            ]
            
            // Background
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
            section.decorationItems = [sectionBackgroundDecoration]

            return section
        }
    }
    
    func createSecondColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // .fractionalWidth(0.6675),
            heightDimension: .estimated(80) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 52, trailing: 20)
        section.interGroupSpacing = CGFloat(32)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]

        return section
    }
    
    func createThirdColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(68)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        return section
    }
}

extension TotalResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if viewModel?.restaurants.isEmpty == true {
                return 1
            } else {
                return viewModel?.restaurants.count ?? 0 > 3 ? 3 : viewModel?.restaurants.count ?? 0
            }
        case 1:
            if viewModel?.groupList.isEmpty == true {
                return 1
            } else {
                return viewModel?.groupList.count ?? 0 > 3 ? 3 : viewModel?.groupList.count ?? 0
            }
        case 2:
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
            if viewModel?.groupList.isEmpty == true {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultEmptyCell", for: indexPath) as? SearchResultEmptyCell else { return UICollectionViewCell() }
                cell.setupCommentLabel(str: "아직 등록된 그룹이 없어요", isHideButton: false)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupInfoCell", for: indexPath) as? GroupInfoCell else { return UICollectionViewCell() }
                cell.setupData(groupData: viewModel?.groupList[indexPath.row])
                return cell
            }
        case 2:
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

extension TotalResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "titleHeaderView", for: indexPath) as! TitleHeaderView
                header.setupTitle(title: "맛집")
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "titleHeaderView", for: indexPath) as! TitleHeaderView
                header.setupTitle(title: "그룹")
                return header
            case 2:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DifferentGroupHeader", for: indexPath) as! DifferentGroupHeader
                return header
            default:
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if viewModel?.restaurants.isEmpty == false {
                viewModel?.coordinator?.showRestaurantDetailViewController(id: viewModel?.restaurants[indexPath.row].id ?? 0)
            }
        case 1:
            // 그룹 상세 페이지로 이동
            if viewModel?.groupList.isEmpty == false {
                viewModel?.coordinator?.showWebViewGroupDetilPage(groupId: viewModel?.groupList[indexPath.row].groupId ?? 0)
            }
        case 2:
            if viewModel?.restaurants.isEmpty == false {
                viewModel?.coordinator?.showRestaurantDetailViewController(id: viewModel?.restaurants[indexPath.row].id ?? 0)
            }
        default:
            return
        }
    }
}
