//
//  GroupResultViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit

class GroupResultViewController: UIViewController {
    
    var viewModel: SearchViewModel?

    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupCollectionView.collectionViewLayout = createLayout()
        groupCollectionView.keyboardDismissMode = .onDrag
        
        let groupResultTitleHeaderView = UINib(nibName: "GroupResultTitleHeaderView", bundle: nil)
        groupCollectionView.register(groupResultTitleHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GroupResultTitleHeaderView")
        
        let emptyNib = UINib(nibName: "SearchResultEmptyCell", bundle: nil)
        groupCollectionView.register(emptyNib, forCellWithReuseIdentifier: "SearchResultEmptyCell")
        
        let groupInfoNib = UINib(nibName: "GroupInfoCell", bundle: nil)
        groupCollectionView.register(groupInfoNib, forCellWithReuseIdentifier: "GroupInfoCell")
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createFirstColumnSection()
            case 1:
                return self.createThirdColumnSection()
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 32, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]

        return section
    }
    
//    func createSecondColumnSection() -> NSCollectionLayoutSection {
//        // Item
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(130),
//            heightDimension: .absolute(207)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//      
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(130), // .fractionalWidth(0.6675),
//            heightDimension: .absolute(207) // .fractionalHeight(0.4215)
//        )
//        
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        // Section
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 20, bottom: 32, trailing: 20)
//        section.orthogonalScrollingBehavior = .continuous
//        section.interGroupSpacing = CGFloat(8)
//        
//        // Header
//        section.boundarySupplementaryItems = [
//            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        ]
//        
//        // Background
//        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "BackgroundViewInset")
//        section.decorationItems = [sectionBackgroundDecoration]
//
//        return section
//    }
    
    func createThirdColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(83)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), // .fractionalWidth(0.6675),
            heightDimension: .absolute(83) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }
}

extension GroupResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if viewModel?.groupList.isEmpty == true {
                return 1
            } else {
                return viewModel?.groupList.count ?? 0
            }
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if viewModel?.groupList.isEmpty == true {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultEmptyCell", for: indexPath) as? SearchResultEmptyCell else { return UICollectionViewCell() }
                cell.setupCommentLabel(str: "아직 등록된 그룹이 없어요", isHideButton: false)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupInfoCell", for: indexPath) as? GroupInfoCell else { return UICollectionViewCell() }
                cell.setupData(groupData: viewModel?.groupList[indexPath.row])
                return cell
            }
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomCell", for: indexPath) as? GroupResultBottomCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//extension GroupResultViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            switch indexPath.section {
//            case 1:
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ResultTitleHeaderView", for: indexPath) as! GroupResultTitleHeaderView
//                return header
//            default:
//                return UICollectionReusableView()
//            }
//        default:
//            return UICollectionReusableView()
//        }
//    }
//}
