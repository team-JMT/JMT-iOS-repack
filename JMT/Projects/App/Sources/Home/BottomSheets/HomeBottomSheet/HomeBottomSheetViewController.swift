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
    
    // MARK: - Properties
    var viewModel: HomeViewModel?
    var fpc: FloatingPanelController!
    
    @IBOutlet weak var bottomSheetCollectionView: UICollectionView!
    @IBOutlet weak var moveTopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header1 = UINib(nibName: "HomeHeaderView", bundle: nil)
        bottomSheetCollectionView.register(header1, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView1")
        let header2 = UINib(nibName: "HomeFilterHeaderView", bundle: nil)
        bottomSheetCollectionView.register(header2, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView2")
        

        self.bottomSheetCollectionView.collectionViewLayout = createLayout()
        self.bottomSheetCollectionView.showAnimatedGradientSkeleton()
    
        setupUI()
    
        setupBind()
    }

    
    // MARK: - SetupBindings
    func setupBind() {
        
        viewModel?.didUpdateGroupRestaurantsData = { [weak self] in
            
            self?.viewModel?.isLodingData = true
            self?.bottomSheetCollectionView.showAnimatedGradientSkeleton()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Task {
                    do {
                        try await self?.fetchGroupRestaurantData()
                        self?.viewModel?.isLodingData = false
                        
                        self?.bottomSheetCollectionView.stopSkeletonAnimation()
                        self?.bottomSheetCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - SetupData
    // 선택한 그룹에 포함된 맛집 정보 가져오기
    func fetchGroupRestaurantData() async throws {
        try await viewModel?.fetchRecentRestaurantsAsync()
        try await viewModel?.fetchGroupRestaurantsAsync()
    }
    
    // MARK: - SetupUI
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
               let isPopularRestaurantsEmpty = self.viewModel?.popularRestaurants.isEmpty ?? true
               let isRestaurantsEmpty = self.viewModel?.restaurants.isEmpty ?? true

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
            heightDimension: .absolute(240) //.absolute(225) // .fractionalHeight(0.4215)
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
    
    // MARK: - Actions
    @IBAction func didTabMoveTopButton(_ sender: Any) {
        bottomSheetCollectionView.setContentOffset(CGPoint(x: 0, y: -bottomSheetCollectionView.contentInset.top), animated: true)
    }
    
    @IBAction func didTabAddButton(_ sender: Any) {
        viewModel?.coordinator?.showSearchRestaurantViewController()
    }
    
    @IBAction func didTabResetButton(_ sender: Any) {
        viewModel?.resetUpdateIndex()
        viewModel?.didUpdateFilterTableView?()
    }
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        viewModel?.saveUpdateIndex()
        viewModel?.didUpdateGroupRestaurantsData?()
        bottomContainerView.removeFromSuperview()
        fpc.dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    func hiddenBottomSheetButton() {
        if viewModel?.popularRestaurants.isEmpty == true && viewModel?.restaurants.isEmpty == true {
            moveTopButton.isHidden = true
            addButton.isHidden = true
        } else {
            moveTopButton.isHidden = false
            addButton.isHidden = false
        }
    }
}

// MARK: - CollectionView Delegate
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard viewModel?.popularRestaurants.isEmpty == false else { return }
            
            if let info = viewModel?.popularRestaurants[indexPath.row] {
                viewModel?.coordinator?.showDetailRestaurantViewController(id: viewModel?.popularRestaurants[indexPath.row].id ?? 0)
            }
        case 1:
            guard viewModel?.restaurants.isEmpty == false else { return }
            
            if let info = viewModel?.restaurants[indexPath.row] {
                viewModel?.coordinator?.showDetailRestaurantViewController(id: viewModel?.restaurants[indexPath.row].id ?? 0)
            }
        default:
            return
        }
    }
}

// MARK: - CollectionView DataSource
extension HomeBottomSheetViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("123123123123 -- 2")
        if viewModel?.popularRestaurants.isEmpty == true {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel?.popularRestaurants.isEmpty == true {
            return 1
        } else {
            switch section {
            case 0:
                return viewModel?.restaurants.count ?? 0 >= 10 ? 10 : viewModel?.popularRestaurants.count ?? 0
            case 1:
                return viewModel?.restaurants.isEmpty == true ? 1 : viewModel?.restaurants.count ?? 0
            default:
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel?.popularRestaurants.isEmpty == true {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyDataCell", for: indexPath) as? PopularEmptyCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        } else {
            if viewModel?.restaurants.isEmpty == true {
                switch indexPath.section {
                case 0:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as? PopularRestaurantCell else { return UICollectionViewCell() }
                    cell.setupData(model: viewModel?.popularRestaurants[indexPath.item])
                    return cell
                case 1:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as? PlaceholderCollectionViewCell else { return UICollectionViewCell() }
                    return cell
                default:
                    return UICollectionViewCell()
                }
            } else {
                switch indexPath.section {
                case 0:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as? PopularRestaurantCell else { return UICollectionViewCell() }
                    cell.hideSkeleton()
                    cell.setupData(model: viewModel?.popularRestaurants[indexPath.item])
                    return cell
                case 1:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as? PopularRestaurantInfoCell else { return UICollectionViewCell() }
                    cell.setupData(model: viewModel?.restaurants[indexPath.item])
                    return cell
                default:
                    return UICollectionViewCell()
                }
            }
        }
    }
}

// MARK: - SkeletonCollectionView DataSource
extension HomeBottomSheetViewController: SkeletonCollectionViewDataSource {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        print("123123123123 -- 1")
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return "firstCell"
        case 1:
            return "secondCell"
        default:
            return ""
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: - HomeFilterHeaderView Delegate
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

// MARK: - PopularEmptyCell Delegate
extension HomeBottomSheetViewController: PopularEmptyCellDelegate {
    func registrationRestaurant() {
        viewModel?.coordinator?.showSearchRestaurantViewController()
    }
}

// MARK: - FloatingPanelController Delegate
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

// MARK: - Extention
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








