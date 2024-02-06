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
        
        let typeheaderView = UINib(nibName: "RestaurantTypeHeaderView", bundle: nil)
        settingInfoCollectionView.register(typeheaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "typeHeaderView")

        viewModel?.didCompleted = {
            
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
       let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createPhotoColumnSection()
            case 1:
                return self.createCommentColumnSection()
            case 2:
                return self.createdrinkingCheckColumnSection()
            case 3:
                return self.createRecommendedMenuColumnSection()
            case 4:
                return self.createTagColumnSection()
                
            default:
                return nil
            }
        }
        
        layout.register(GrayBackgroundView.self, forDecorationViewOfKind: "GrayBackgroundView")
        layout.register(GrayBackgroundViewInset.self, forDecorationViewOfKind: "GrayBackgroundViewInset")
        return layout
    }
    
    func createPhotoColumnSection() -> NSCollectionLayoutSection {
    
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120), // .fractionalWidth(0.6675),
            heightDimension: .absolute(120) // .fractionalHeight(0.4215)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 36, trailing: 20)
        section.interGroupSpacing = CGFloat(16)
        
        // Header
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]

        return section
    }
    
    func createCommentColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(305)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 36, trailing: 20)
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createdrinkingCheckColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 36, trailing: 20)
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundViewInset")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    func createRecommendedMenuColumnSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(1)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20)
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        return section
    }
    
    func createTagColumnSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .absolute(33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(33))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 100, trailing: 20)
        
        // Background
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
    
    @IBAction func didTabRegistrationButton(_ sender: Any) {
        viewModel?.coordinator?.showRegistrationRestaurantTypeBottomSheetViewController()
    }
}

extension RegistrationRestaurantInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (viewModel?.selectedImages.count ?? 0) + 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 6
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraCell", for: indexPath) as? InfoCameraCell else { return UICollectionViewCell() }
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? InfoPhotoCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.menuImageView.image = viewModel?.selectedImages[indexPath.row - 1].image
                return cell
            }
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as? InfoCommentCell else { return UICollectionViewCell() }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkingCheckCell", for: indexPath) as? DrinkingCheckCell else { return UICollectionViewCell() }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedMenuCell", for: indexPath) as? RecommendedMenuCell else { return UICollectionViewCell() }
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? RecommendedMenuTagCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension RegistrationRestaurantInfoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "typeHeaderView", for: indexPath) as? RestaurantTypeHeaderView else { return UICollectionReusableView() }
                header.delegate = self
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
            switch indexPath.row {
            case 0 :
                viewModel?.coordinator?.showImagePicker()
            default:
                if let cell = collectionView.cellForItem(at: indexPath) as? InfoPhotoCell {
                    print(cell.deleteButton.tag)
                }
            }
        case 2:
            print("2")
            
        default:
            return
        }
    }
}


extension RegistrationRestaurantInfoViewController: RestaurantTypeHeaderViewDelegate {
    func didTabChangeTypeButton() {
        viewModel?.coordinator?.showRegistrationRestaurantTypeBottomSheetViewController()
    }
}
 
extension RegistrationRestaurantInfoViewController: InfoPhotoCellDelegate {
    func didTabDeleteButton(in cell: UICollectionViewCell) {
        guard let indexPath = settingInfoCollectionView.indexPath(for: cell) else { return  }
        
        viewModel?.selectedImages.remove(at: indexPath.item - 1)
        
        settingInfoCollectionView.performBatchUpdates {
            settingInfoCollectionView.deleteItems(at: [indexPath])
        }
    }
}
