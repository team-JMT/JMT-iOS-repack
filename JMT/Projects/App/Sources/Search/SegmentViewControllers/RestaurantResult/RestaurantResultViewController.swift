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

        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdate), name: .didUpdateGroup, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .didUpdateGroup, object: nil)
    }
    
    @objc func handleDataUpdate() {
        DispatchQueue.main.async {
            self.restaurantCollectionView.reloadData()
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0:
                return self.createRestaurantInfoSection()
            case 1:
                return self.createOutBoundrestaurantSection()
            default:
                return nil
            }
        }
        
        layout.register(CollectionInset12BackgroundWhiteView.self, forDecorationViewOfKind: "InsetWhiteBackgroundView")
        layout.register(CollectionBackgroundGrayView.self, forDecorationViewOfKind: "GrayBackgroundView")
        return layout
    }
    
    func createRestaurantInfoSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 32, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "InsetWhiteBackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createOutBoundrestaurantSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        
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
                cell.setupOutBoundrestaurantData(outBoundRestaurantData: viewModel?.outBoundrestaurants[indexPath.row])
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
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "title2Header", for: indexPath) as? RestaurantTitle2HeaderView else { return UICollectionReusableView() }
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
            if viewModel?.restaurants.isEmpty == false {
                viewModel?.coordinator?.showRestaurantDetailViewController(id: viewModel?.outBoundrestaurants[indexPath.row].id ?? 0)
            }
        default:
            return
        }
    }
}
