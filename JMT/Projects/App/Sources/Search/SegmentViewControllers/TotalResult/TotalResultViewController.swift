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
        
        viewModel?.didUpdateGroup = {
            DispatchQueue.main.async {
                self.totalResultCollectionView.reloadData()
            }
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            
            if self.viewModel?.isEmptyGroup == true {
                return self.createSecondColumnSection()
            } else {
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
        if viewModel?.isEmptyGroup == true {
            return 1
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel?.isEmptyGroup == true {
            return viewModel?.groupList.count ?? 0
        } else {
            switch section {
            case 0:
                return 3
            case 1:
                return 3
            case 2:
                return 3
            default:
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(viewModel?.groupList)
        if viewModel?.isEmptyGroup == true {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as? GroupInfoCell else { return UICollectionViewCell() }
            cell.setupData(groupData: viewModel?.groupList[indexPath.row])
            return cell
        } else {
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath)
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath)
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath)
                return cell
            default:
                return UICollectionViewCell()
            }
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
                if viewModel?.isEmptyGroup == true {
                    header.setupTitle(title: "그룹")
                } else {
                    header.setupTitle(title: "맛집")
                }
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
        print("1231231231", viewModel?.isEmptyGroup)
        if viewModel?.isEmptyGroup == true {
            
            let groupId = viewModel?.groupList[indexPath.row].groupId ?? 0
            
            let urlString = "https://jmt-frontend-ad7b8.web.app/group-detail/\(groupId)/"
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.addValue("Bearer \(DefaultKeychainService.shared.accessToken)", forHTTPHeaderField: "Authorization")
                
                let storyboard = UIStoryboard(name: "Group", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "OriginWebViewController") as? OriginWebViewController else { return }
                vc.loadWebViewWithRoute(route: "group")
                
            } else {
                print("123123123123")
            }

        } else {
            switch indexPath.section {
            case 0:
                viewModel?.coordinator?.showRestaurantDetailViewController()
            case 1:
                return
            case 2:
                viewModel?.coordinator?.showRestaurantDetailViewController()
            default:
                return
            }
        }
        
      
    }
}
