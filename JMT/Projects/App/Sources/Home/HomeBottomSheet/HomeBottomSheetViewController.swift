//
//  HomeBottomSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/23.
//

import UIKit

class HomeBottomSheetViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var bottomSheetCollectionView: UICollectionView!
    @IBOutlet weak var moveTopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSheetCollectionView.collectionViewLayout = createLayout()
        let header1 = UINib(nibName: "HomeHeaderView", bundle: nil)
        bottomSheetCollectionView.register(header1, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView1")
        let header2 = UINib(nibName: "HomeFilterHeaderView", bundle: nil)
        bottomSheetCollectionView.register(header2, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView2")
    
        setupUI()
        
        viewModel?.didUpdateBottomSheetTableView = {
            self.bottomSheetCollectionView.reloadData()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
       UICollectionViewCompositionalLayout { [weak self] sectionIndex, env -> NSCollectionLayoutSection? in
           
           guard let self = self else { return nil }
           
           let isPopularRestaurantsEmpty = self.viewModel?.popularRestaurants.isEmpty ?? true
           let adjustedSectionIndex = isPopularRestaurantsEmpty ? sectionIndex + 1 : sectionIndex
           
           switch adjustedSectionIndex {
           case 0:
               return self.createFirstColumnSection() // popularRestaurants 섹션
           case 1:
               return self.createSecondColumnSection() // restaurants 섹션
           default:
               return nil
           }
       }
    }
    
    func createFirstColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(250), // .fractionalWidth(0.6675),
            heightDimension: .absolute(225) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 40, trailing: 20)
        section.interGroupSpacing = CGFloat(20)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]

        return section
    }
    
    func createSecondColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(400)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
     

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 32, trailing: 20)
        section.interGroupSpacing = 32
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(26)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]

        return section
        
    }
    
    func setupUI() {
        moveTopButton.layer.cornerRadius = moveTopButton.frame.height / 2
        addButton.layer.cornerRadius = addButton.frame.height / 2
    }
    
    @IBAction func didTabMoveTopButton(_ sender: Any) {
        
    }
    
    @IBAction func didTabAddButton(_ sender: Any) {
        viewModel?.coordinator?.showSearchRestaurantViewController()
    }
}

extension HomeBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if viewModel?.popularRestaurants.isEmpty == true  {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView2", for: indexPath) as! HomeFilterHeaderView
                header.delegate = self
                header.updateFilterButtonTitle(viewModel: viewModel)
                return header
            } else {
                switch indexPath.section {
                case 0:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView1", for: indexPath) as! HomeHeaderView
                    return header
                case 1:
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView2", for: indexPath) as! HomeFilterHeaderView
                    header.delegate = self
                    header.updateFilterButtonTitle(viewModel: viewModel)
                    return header
                default:
                    return UICollectionReusableView()
                }
            }
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeBottomSheetViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.popularRestaurants.isEmpty == true ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 && viewModel?.popularRestaurants.isEmpty == false {
            return viewModel?.popularRestaurants.count ?? 0 // 첫 번째 섹션의 아이템 수
            
        } else if section == 1 || (section == 0 && viewModel?.popularRestaurants.isEmpty == true) {
            return viewModel?.restaurants.count ?? 0 // 두 번째 섹션의 아이템 수
        }
        return 0 // 그 외의 경우에는 아이템 없음
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel?.popularRestaurants.isEmpty == true {
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? PopularRestaurantInfoCell else { return UICollectionViewCell() }
                return cell
            } else {
                return UICollectionViewCell()
            }
        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? PopularRestaurantCell else { return UICollectionViewCell() }
                cell.layer.borderColor = JMTengAsset.gray200.color.cgColor
                cell.layer.borderWidth = 1
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? PopularRestaurantInfoCell else { return UICollectionViewCell() }
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
}

extension HomeBottomSheetViewController: HomeFilterHeaderViewDelegate {
    func didTabFilter1Button() {
        viewModel?.updateSortType(type: .sort)
        viewModel?.coordinator?.showFilterBottomSheetViewController()
    }
    
    func didTabFilter2Button() {
        viewModel?.updateSortType(type: .category)
        viewModel?.coordinator?.showFilterBottomSheetViewController()
    }
    
    func didTabFilter3Button() {
        viewModel?.updateSortType(type: .drinking)
        viewModel?.coordinator?.showFilterBottomSheetViewController()
    }
}
