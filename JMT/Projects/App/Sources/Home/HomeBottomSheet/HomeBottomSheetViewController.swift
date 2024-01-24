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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
   
}

extension HomeBottomSheetViewController: UICollectionViewDelegate {
    
}

extension HomeBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}
