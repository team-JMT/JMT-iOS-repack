//
//  RestaurantDetailReviewViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

class RestaurantDetailReviewViewController: UIViewController {

    var viewModel: RestaurantDetailReviewViewModel?
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reviewCollectionView.collectionViewLayout = createLayout()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.reviewCollectionView.reloadData()
            
        }
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        section.interGroupSpacing = 16
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(22)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        return section
    }
}

extension RestaurantDetailReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.reviews.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as? RestaurantDetailReviewCell else { return UICollectionViewCell() }
        cell.configureCell(data: viewModel?.reviews[indexPath.row] ?? "", index: indexPath.row)
        cell.sizeToFit()
        return cell
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

