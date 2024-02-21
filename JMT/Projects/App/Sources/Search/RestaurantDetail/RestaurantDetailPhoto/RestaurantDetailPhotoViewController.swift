//
//  RestaurantDetailPhotoViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/02.
//

import UIKit

class RestaurantDetailPhotoViewController: UIViewController {

    var viewModel: RestaurantDetailPhotoViewModel?
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 41 + 56, right: 20)
        
    }
}

extension RestaurantDetailPhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 37)
    }
}

extension RestaurantDetailPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

extension RestaurantDetailPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 4 // 셀 사이의 간격을 가정
        
        // contentInset과 minimumInteritemSpacing을 고려하여 사용 가능한 총 너비 계산
        // contentInset 리딩 20, 트레일링 20 및 셀 사이 간격
        let totalSpacing = (2 * 20) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        // 셀의 높이와 너비를 동일하게 설정하여 정사각형으로 만듦
        return CGSize(width: width, height: width)
    }
}
