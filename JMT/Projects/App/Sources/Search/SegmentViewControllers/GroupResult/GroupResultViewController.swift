//
//  GroupResultViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/30.
//

import UIKit

class GroupResultViewController: UIViewController {
    
    var viewModel: SearchViewModel?

    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupCollectionView.collectionViewLayout = createLayout()
        groupCollectionView.keyboardDismissMode = .onDrag
        
        let groupResultTitleHeaderView = UINib(nibName: "GroupResultTitleHeaderView", bundle: nil)
        groupCollectionView.register(groupResultTitleHeaderView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GroupResultTitleHeaderView")
        
        let emptyNib = UINib(nibName: "SearchResultEmptyCell", bundle: nil)
        groupCollectionView.register(emptyNib, forCellWithReuseIdentifier: "SearchResultEmptyCell")
        
        let groupInfoNib = UINib(nibName: "GroupInfoCell", bundle: nil)
        groupCollectionView.register(groupInfoNib, forCellWithReuseIdentifier: "GroupInfoCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataUpdate), name: .didUpdateGroup, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .didUpdateGroup, object: nil)
    }
    
    @objc func handleDataUpdate() {
        DispatchQueue.main.async {
            self.groupCollectionView.reloadData()
        }
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createGroupInfoSection()
            case 1:
                return self.createNewGroupSection()
            default:
                return nil
            }
        }
        
        layout.register(CollectionInset12BackgroundWhiteView.self, forDecorationViewOfKind: "InsetWhiteBackgroundView")
        layout.register(CollectionBackgroundGrayView.self, forDecorationViewOfKind: "GrayBackgroundView")
        layout.register(CollectionBackgroundWhiteView.self, forDecorationViewOfKind: "WhiteBackgroundView")
        
        return layout
    }
    
    func createGroupInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 32, trailing: 20)
        section.interGroupSpacing = CGFloat(12)
        
        if viewModel?.groupList.isEmpty == true {
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "WhiteBackgroundView")
            section.decorationItems = [sectionBackgroundDecoration]
        } else {
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "InsetWhiteBackgroundView")
            section.decorationItems = [sectionBackgroundDecoration]
        }
        
        return section
    }
    
    func createNewGroupSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(83)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(83)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = CGFloat(12)

        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "GrayBackgroundView")
        section.decorationItems = [sectionBackgroundDecoration]
        
        return section
    }
}

extension GroupResultViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.groupList.isEmpty == true ? 1 : 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if viewModel?.groupList.isEmpty == true {
                return 1
            } else {
                return viewModel?.groupList.count ?? 0
            }
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if viewModel?.groupList.isEmpty == true {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultEmptyCell", for: indexPath) as? SearchResultEmptyCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.setupCommentLabel(str: "아직 등록된 그룹이 없어요", isHideButton: false)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupInfoCell", for: indexPath) as? GroupInfoCell else { return UICollectionViewCell() }
                cell.setupData(groupData: viewModel?.groupList[indexPath.row])
                return cell
            }
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomCell", for: indexPath) as? GroupResultBottomCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension GroupResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if viewModel?.restaurants.isEmpty == false {
                viewModel?.coordinator?.showWebViewGroupDetilPage(groupId: viewModel?.groupList[indexPath.row].groupId ?? 0)
            }
        default:
            return
        }
    }
}

extension GroupResultViewController: SearchResultEmptyCellDelegate {
    func didTabCreateGroupButton() {
        viewModel?.coordinator?.showWebViewCreateGroupPage()
    }
}
