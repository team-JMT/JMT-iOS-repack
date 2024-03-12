//
//  SecondSegmentTableViewCell.swift
//  JMTeng
//
//  Created by 이지훈 on 3/11/24.
//

import UIKit

class SecondSegmentTableViewCell: UITableViewCell{

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var Resturantexplanation: UILabel!
    @IBOutlet weak var mainCollection: UICollectionView!
    
    
    private var imageViews: [UIImageView] = []
    var imageNames: [String] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Set horizontal scroll
        mainCollection.collectionViewLayout = layout
        
        super.awakeFromNib()
        // Delegate와 DataSource 설정
        self.mainCollection.delegate = self
        self.mainCollection.dataSource = self
        self.mainCollection.reloadData()
    }


    func configure(with data: RestaurantData) {
        Resturantexplanation.text = data.description
        imageNames = data.imageName
        mainCollection.reloadData() // Refresh the collection view with new data
    }
}


extension SecondSegmentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPageReviewCollectionViewCell", for: indexPath) as? myPageReviewCollectionViewCell else {
            fatalError("Unable to dequeue myPageReviewCollectionViewCell")
        }
        let imageName = imageNames[indexPath.row]
        cell.configure(imageName: imageName)
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
        
    
}
