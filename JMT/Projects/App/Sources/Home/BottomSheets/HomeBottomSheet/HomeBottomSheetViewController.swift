//
//  HomeBottomSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/23.
//

import UIKit
import SkeletonView
import FloatingPanel

class HomeBottomSheetViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    var fpc: FloatingPanelController!
    
    @IBOutlet weak var bottomSheetCollectionView: UICollectionView!
    @IBOutlet weak var moveTopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var filterTableViewHight: Double = 0.0
    
    var testData = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header1 = UINib(nibName: "HomeHeaderView", bundle: nil)
        bottomSheetCollectionView.register(header1, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView1")
        let header2 = UINib(nibName: "HomeFilterHeaderView", bundle: nil)
        bottomSheetCollectionView.register(header2, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView2")
        
        bottomSheetCollectionView.collectionViewLayout = createLayout()
    
        setupUI()
        
        bottomSheetCollectionView.showAnimatedGradientSkeleton()
        
        viewModel?.didUpdateSkeletonView = {
            self.view.showAnimatedGradientSkeleton()
        }
        
        viewModel?.didUpdateBottomSheetTableView = {
            
            DispatchQueue.main.async {

                self.hiddenBottomSheetButton()
                self.bottomSheetCollectionView.reloadData()
                self.bottomSheetCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
            }
        }
        
        
        viewModel?.didUpdateIndex = { index in
            self.bottomSheetCollectionView.scrollToItem(at: IndexPath(row: index, section: 1), at: .top, animated: true)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
       UICollectionViewCompositionalLayout { [weak self] sectionIndex, env -> NSCollectionLayoutSection? in
           
           guard let self = self else { return nil }
        
           if viewModel?.isLodingData == true {
               switch sectionIndex {
               case 0:
                   return self.createFirstColumnSection()
               case 1:
                   return self.createSecondColumnSection()
               default:
                   return nil
               }
           } else {
               let isPopularRestaurantsEmpty = self.viewModel?.filterPopularRestaurants.isEmpty ?? true
               let isRestaurantsEmpty = self.viewModel?.filterRestaurants.isEmpty ?? true

               if isPopularRestaurantsEmpty && isRestaurantsEmpty {
                   return self.createEmptyColumnSection()
               }

               switch sectionIndex {
               case 0:
                   return self.createFirstColumnSection() // popularRestaurants 섹션
               case 1:
                   return self.createSecondColumnSection() // restaurants 섹션
               default:
                   return nil
               }
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
    
    func createEmptyColumnSection() -> NSCollectionLayoutSection {
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
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
     
        // Section
        let section = NSCollectionLayoutSection(group: group)

        return section
    }
    
    func setupUI() {
        moveTopButton.layer.cornerRadius = moveTopButton.frame.height / 2
        addButton.layer.cornerRadius = addButton.frame.height / 2
        
        // 리셋 버튼
        resetButton.layer.cornerRadius = 8
        resetButton.layer.borderColor = JMTengAsset.gray200.color.cgColor
        resetButton.layer.borderWidth = 1
        
        // 확인 버튼
        doneButton.layer.cornerRadius = 8
    }
    
    func setupBottomContainerView() {
        fpc.view.addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func hiddenBottomSheetButton() {
        if viewModel?.filterPopularRestaurants.isEmpty == true && viewModel?.filterRestaurants.isEmpty == true {
            moveTopButton.isHidden = true
            addButton.isHidden = true
        } else {
            moveTopButton.isHidden = false
            addButton.isHidden = false
        }
    }
    
    @IBAction func didTabMoveTopButton(_ sender: Any) {
        bottomSheetCollectionView.setContentOffset(CGPoint(x: 0, y: -bottomSheetCollectionView.contentInset.top), animated: true)
    }
    
    @IBAction func didTabAddButton(_ sender: Any) {
        viewModel?.coordinator?.showSearchRestaurantViewController()
    }
    
    @IBAction func didTabResetButton(_ sender: Any) {
        viewModel?.resetUpdateIndex()
    }
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        viewModel?.saveUpdateIndex()
        viewModel?.fetchRestaurantsData()
        bottomContainerView.removeFromSuperview()
        fpc.dismiss(animated: true)
    }
}

extension HomeBottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView1", for: indexPath) as! HomeHeaderView
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView2", for: indexPath) as! HomeFilterHeaderView
                header.updateFilterButtonTitle(viewModel: viewModel)
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
            
        if viewModel?.filterPopularRestaurants.isEmpty == true && viewModel?.filterRestaurants.isEmpty == true {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel?.filterPopularRestaurants.isEmpty == true && viewModel?.filterRestaurants.isEmpty == true {
            return 1
        } else {
            switch section {
            case 0:
                return viewModel?.filterPopularRestaurants.count ?? 0
            case 1:
                return viewModel?.filterRestaurants.isEmpty == true ? 1 : viewModel?.filterRestaurants.count ?? 0
            default:
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if viewModel?.filterPopularRestaurants.isEmpty == true && viewModel?.filterRestaurants.isEmpty == true {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyDataCell", for: indexPath) as? PopularEmptyCell else { return UICollectionViewCell()}
            cell.delegate = self
            return cell
        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? PopularRestaurantCell else { return UICollectionViewCell() }
                cell.setupData(model: viewModel?.filterPopularRestaurants[indexPath.row])
                return cell
            case 1:
                if viewModel?.filterRestaurants.isEmpty == true {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as? PlaceholderCollectionViewCell else { return UICollectionViewCell() }
                    return cell

                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as? PopularRestaurantInfoCell else { return UICollectionViewCell() }
                    cell.setupData(model: viewModel?.filterRestaurants[indexPath.row])
                    return cell
                }
            default:
                return UICollectionViewCell()
            }
        }
    }
}

extension HomeBottomSheetViewController: SkeletonCollectionViewDataSource {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return "cell1"
        case 1:
            return "cell2"
        default:
            return ""
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 5
        default:
            return 0
        }
    }
}

extension HomeBottomSheetViewController: HomeFilterHeaderViewDelegate {
    func didTabFilter1Button() {
        viewModel?.updateSortType(type: .sort)
        showBottomSheetView()
    }
    
    func didTabFilter2Button() {
        viewModel?.updateSortType(type: .category)
        showBottomSheetView()
        setupBottomContainerView()
    }
    
    func didTabFilter3Button() {
        viewModel?.updateSortType(type: .drinking)
        showBottomSheetView()
        setupBottomContainerView()
    }
}

extension HomeBottomSheetViewController: PopularEmptyCellDelegate {
    func registrationRestaurant() {
        viewModel?.coordinator?.showSearchRestaurantViewController()
    }
}


extension HomeBottomSheetViewController {
    func showBottomSheetView() {
        
        let storyboard = UIStoryboard(name: "FilterBottomSheet", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FilterBottomSheetViewController") as? FilterBottomSheetViewController else { return }
    
        vc.viewModel = self.viewModel
        
        fpc = FloatingPanelController(delegate: self)
        fpc.set(contentViewController: vc)
        
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true

        switch viewModel?.sortType {
        case .sort, .drinking:
            fpc.setPanelStyle(radius: 24, isHidden: true)
            fpc.panGestureRecognizer.isEnabled = false
        case .category:
            fpc.setPanelStyle(radius: 24, isHidden: false)
            fpc.panGestureRecognizer.isEnabled = true
        default:
            return
        }
    
        self.present(fpc, animated: true)
    }
}

extension HomeBottomSheetViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {

        switch viewModel?.sortType {
        case .sort:
            return SortFloatingPanelLayout()
        case .category:
            return CategoryFloatingPanelLayout()
        case .drinking:
            return DrinkingFloatingPanelLayout()
        case .none:
            return SortFloatingPanelLayout()
        }
    }
    
    // 바텀시트 사라지기 전 지우기
    func floatingPanelWillRemove(_ fpc: FloatingPanelController) {
        bottomContainerView.removeFromSuperview()
    }
}

class SortFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(absoluteInset: 294, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}

class CategoryFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] =
    
    [
        .full: FloatingPanelLayoutAnchor(fractionalInset: 0.95, edge: .bottom, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}


class DrinkingFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] =
    
    [
        .half: FloatingPanelLayoutAnchor(absoluteInset: 240 + 110, edge: .bottom, referenceGuide: .safeArea)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}