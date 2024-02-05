//
//  RegistrationRestaurantInfoViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit

class RegistrationRestaurantInfoViewController: UIViewController {

    var viewModel: RegistrationRestaurantInfoViewModel?
    
    @IBOutlet weak var settingInfoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "맛집 이름은 여기에"
        settingInfoCollectionView.collectionViewLayout = createLayout()
        
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
       UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createFirstColumnSection()
            case 1:
                return nil
                
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
    
    @IBAction func didTabRegistrationButton(_ sender: Any) {
        viewModel?.coordinator?.showRegistrationRestaurantMenuBottomSheetViewController()
    }
}

extension RegistrationRestaurantInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension RegistrationRestaurantInfoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: <#T##IndexPath#>)
            }
        }
    }
    
}


