//
//  RegistrationRestaurantInfoViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit

class RegistrationRestaurantInfoViewController: UIViewController, KeyboardEvent {

    var transformView: UIView { return self.view }
    
    var viewModel: RegistrationRestaurantInfoViewModel?
    
    @IBOutlet weak var settingInfoCollectionView: UICollectionView!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = viewModel?.info?.placeName ?? ""
        settingInfoCollectionView.collectionViewLayout = createLayout()
        settingInfoCollectionView.keyboardDismissMode = .onDrag
        
        let typeheaderView = UINib(nibName: "RestaurantTypeHeaderView", bundle: nil)
        settingInfoCollectionView.register(typeheaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "typeHeaderView")
        
        setCustomNavigationBarBackButton(isSearchVC: false)
        registrationButton.layer.cornerRadius = 8

        viewModel?.didCompletedFilterType = {
            self.updateSection(section: 0)
        }
        
        viewModel?.didCompletedTags = { bool in
            
            if let cell = self.settingInfoCollectionView.cellForItem(at: IndexPath(row: 0, section: 3)) as? RecommendedMenuCell {
                
                if bool {
                    cell.tagTextField.text = ""
                    self.updateSection(section: 4)
                } else {
                    cell.tagTextField.text = ""
                }
            }
        }
        
        viewModel?.didCompletedDeleteTag = {
            self.updateSection(section: 4)
        }
        
        viewModel?.didCompletedCheckInfo = { type in
            switch type {
            case .filterType:
                self.settingInfoCollectionView.setContentOffset(CGPoint(x: 0, y: -self.settingInfoCollectionView.contentInset.top), animated: true)
            case .commentString:
                self.settingInfoCollectionView.moveToScroll(section: 1, row: 0, margin: 100)
            case .drinkingComment:
                self.settingInfoCollectionView.moveToScroll(section: 2, row: 0, margin: 100)
            case .tags:
                self.settingInfoCollectionView.moveToScroll(section: 3, row: 0, margin: 100)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardEvent(keyboardWillShow: { noti in
            
            guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            if let currentResponder = UIResponder.currentResponder {
                switch currentResponder {
                case let textField as UITextField:
                    switch textField.tag {
                    case 0:
                        self.settingInfoCollectionView.moveToScroll(section: 2, row: 0, margin: 100)
                    case 1:
                        // Y축으로 키보드의 상단 위치
                        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
                        // 현재 선택한 텍스트 필드의 Frame 값
                        let convertedTextFieldFrame = self.settingInfoCollectionView.convert(textField.frame,
                                                                   from: textField.superview)
                        // Y축으로 현재 텍스트 필드의 하단 위치
                        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
                        
                        // Y축으로 텍스트필드 하단 위치가 키보드 상단 위치보다 클 때
                        if textFieldBottomY > keyboardTopY {
                            let newFrame = keyboardFrame.cgRectValue.height - 110
                            let insets = UIEdgeInsets(top: 0, left: 0, bottom: newFrame, right: 0)
                            self.settingInfoCollectionView.contentInset = insets
                            self.settingInfoCollectionView.moveToScroll(section: 3, row: 0, margin: 100)
                        }
                    default:
                        print("default")
                    }
                case let textView as UITextView:
                    switch textView.tag {
                    case 0:
                        self.settingInfoCollectionView.moveToScroll(section: 1, row: 0, margin: 100)
                    default:
                        print("default")
                    }
                default:
                    break // 다른 타입의 응답자인 경우 처리하지 않음
                }
            }
        }, keyboardWillHide: { noti in
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.settingInfoCollectionView.contentInset = insets
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    func updateSection(section: Int) {
        UIView.performWithoutAnimation {
            self.settingInfoCollectionView.reloadSections(IndexSet(integer: section))
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
        
        print(viewModel?.info)
        
        print("------------")
        
        viewModel?.coordinator?.showButtonPopupViewController()
        
        print(viewModel?.filterType)
        print(viewModel?.selectedImages)
        print(viewModel?.commentString)
        print(viewModel?.isDrinking)
        print(viewModel?.drinkingComment)
        print(viewModel?.tags)
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
            return viewModel?.tags.count ?? 0
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
                cell.photoCountLabel.text = "\(viewModel?.selectedImages.count ?? 0)/10"
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? InfoPhotoCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.menuImageView.image = viewModel?.selectedImages[indexPath.row - 1]
                return cell
            }
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as? InfoCommentCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkingCheckCell", for: indexPath) as? DrinkingCheckCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedMenuCell", for: indexPath) as? RecommendedMenuCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? RecommendedMenuTagCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configData(text: viewModel?.tags[indexPath.row])
            cell.deleteButton.tag = indexPath.row
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
                
                if viewModel?.isSelectedFilterType != false {
                    header.updateTypeLabel(text: viewModel?.typeNames[viewModel?.filterType ?? 0] ?? "")
                    header.updateTypeHeaderView()
                }
                
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
            settingInfoCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
            settingInfoCollectionView.deleteItems(at: [indexPath])
        }
    }
}

extension RegistrationRestaurantInfoViewController: InfoCommentCellDelegate {
    func updateInfoComment(text: String) {
        viewModel?.updateCommentString(text: text)
    }
}

extension RegistrationRestaurantInfoViewController: DrinkingCheckCellDelegate {
    func didTabCheckButton(isSelected: Bool) {
        viewModel?.updateIsDrinking(isDrinking: isSelected)
    }

    func updateDrinkingComment(text: String) {
        viewModel?.updateDrinkingComment(text: text)
    }
}

extension RegistrationRestaurantInfoViewController: RecommendedMenuCellDelegate {
    func updateTag(text: String) {
        viewModel?.updateTags(tag: text)
    }
}

extension RegistrationRestaurantInfoViewController: RecommendedMenuTagCellDelegate {
    func didTabDeleteButton(index: Int) {
        viewModel?.deleteTags(index: index)
    }
}

extension RegistrationRestaurantInfoViewController: ButtonPopupDelegate {
    func didTabDoneButton() { }
    
    func didTabCloseButton() {
        viewModel?.checkNotInfo()
    }
}