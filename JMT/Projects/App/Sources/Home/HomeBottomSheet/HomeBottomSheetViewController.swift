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
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
       UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createFirstColumnSection()
            case 1:
                return self.createSecondColumnSection()
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
        
    }
    
    
}

extension HomeBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:

            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView1", for: indexPath) as! FirstHeaderView
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView2", for: indexPath) as! SecondHeaderView
                header.delegate = self
                return header
            default:
                return UICollectionReusableView()
            }

        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeBottomSheetViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            cell.layer.borderColor = JMTengAsset.gray200.color.cgColor
            cell.layer.borderWidth = 1
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension HomeBottomSheetViewController: SecondHeaderViewDelegate {
    func didTabFilter1Button() {
        viewModel?.filterType = 0
        viewModel?.coordinator?.showFilterBottomSheetViewController()
    }
    
    func didTabFilter2Button() {
        viewModel?.filterType = 1
        viewModel?.coordinator?.showFilterBottomSheetViewController()
    }
    
    func didTabFilter3Button() {
        viewModel?.filterType = 2
        viewModel?.coordinator?.showFilterBottomSheetViewController()
    }
}
