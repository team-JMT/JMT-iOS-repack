//
//  PhotoKitViewController.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import UIKit
import SnapKit

class PhotoKitViewController: UIViewController {
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumArrowImageView: UIImageView!
    @IBOutlet weak var albumListView: UIView!
    @IBOutlet weak var albumListTableView: UITableView!
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var photoCountView: UIView!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    @IBOutlet weak var selectedButtonView: UIView!
    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var hiddenViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumListViewBottomConstraint: NSLayoutConstraint!

    var didSelectItems: (([UIImage]) -> Void)?
    
    let albumsManager = AlbumsManager()

    var selectedPhotos = [PhotoInfo]()
    var totalSelectPhotoCount = 0
    
    var isAnimating = false
    
    var currentAlbumIndex: Int = 0 {
        didSet {
            albumsManager.albumImagesResult(index: currentAlbumIndex) {
                self.setAlbumTitle(self.albumsManager.albums[self.currentAlbumIndex])
                DispatchQueue.main.async {
                    self.updateSelectedImages()
                    self.photoListCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumsManager.fetchAlbums {
            self.albumsManager.albumImagesResult(index: self.currentAlbumIndex) {
                self.setAlbumTitle(self.albumsManager.albums[self.currentAlbumIndex])
            }
        }
 
        setupUI()
        
        NSLayoutConstraint.deactivate([albumListViewBottomConstraint])
        albumListViewBottomConstraint = albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([albumListViewBottomConstraint])
        
        hiddenViewHeightConstraint.constant = Utils.safeAreaBottomInset()
    }
    
    func setupUI() {
        
        selectedButton.layer.cornerRadius = 8
        
        photoCountLabel.text = "사진 최대 \(photoKitConfig.library.maxNumberOfItems)장까지 등록 가능합니다"
        selectedButton.setTitle("선택하기 \(selectedPhotos.count)/\(photoKitConfig.library.maxNumberOfItems)", for: .normal)
        
        if photoKitConfig.library.defaultMultipleSelection {
            photoCountView.isHidden = false
            selectedButtonView.isHidden = false
        } else {
            photoCountView.isHidden = true
            selectedButtonView.isHidden = true
        }
    }
    
    func updateSelectedImages() {

        if !selectedPhotos.isEmpty {

            let currentAlbumPhotos = selectedPhotos.filter { $0.albumIndex == currentAlbumIndex }

            for photo in currentAlbumPhotos {
                albumsManager.photos[photo.selectedIndex] = photo
            }
        }
    }
    
    func updateAlbumTableViewConstraints() {
        guard !isAnimating else { return }
        
        isAnimating = true
    
        NSLayoutConstraint.deactivate([albumListViewBottomConstraint])

        albumListViewBottomConstraint = albumListView.frame.height == 0.0
        ? albumListView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor)
        : albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([albumListViewBottomConstraint])
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.isAnimating = false
        }
    }
    
    func setAlbumTitle(_ album: AlbumInfo) {
        albumTitleLabel.text = album.title
    }
    
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        let images = selectedPhotos.compactMap { $0.image }
        self.didSelectItems?(images)
        dismiss(animated: true)
    }
    
    @IBAction func didTabCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTabAlbumTitleButton(_ sender: Any) {
        updateAlbumTableViewConstraints()
    }
}

extension PhotoKitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentAlbumIndex = indexPath.row
        updateAlbumTableViewConstraints()
    }
}

extension PhotoKitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsManager.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumCell else { return UITableViewCell() }
        cell.prepare(info: albumsManager.albums[indexPath.row])
        return cell
    }
}

extension PhotoKitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if photoKitConfig.library.defaultMultipleSelection {
            
            var info = albumsManager.photos[indexPath.item]
        
            if totalSelectPhotoCount >= photoKitConfig.library.maxNumberOfItems && info.selectedOrder == SelectionOrder.none {
                print("사진 선택 불가능")
                return
            }
            
            var updatingIndexPaths: [IndexPath] = []
            
            if case .selected = info.selectedOrder {
                
                albumsManager.updatePhotoSelectionState(for: info, selectedOrder: .none)
                
                selectedPhotos.removeAll(where: { $0.localIdentifier == info.localIdentifier })
                
                selectedPhotos.redefineOrders()
                
                let currentAlbumPhotos = selectedPhotos.filter({ $0.albumIndex == currentAlbumIndex })
                
                albumsManager.reflectSelectedPhotosOrder(for: currentAlbumPhotos)
                
                updatingIndexPaths = [indexPath] + currentAlbumPhotos.map({ IndexPath(row: $0.selectedIndex, section: 0)})
                
                totalSelectPhotoCount -= 1
            } else {
                
                let maxOrder = selectedPhotos.maxSelectedOrder()
                
                info.selectedOrder = .selected(maxOrder + 1)
                
                selectedPhotos.append(info)
               
                let currentAlbumPhotos = selectedPhotos.filter({ $0.albumIndex == currentAlbumIndex })
                
                albumsManager.updatePhotoSelectionState(for: info, selectedOrder: .selected(maxOrder + 1))
                
                updatingIndexPaths = currentAlbumPhotos.map({ IndexPath(row: $0.selectedIndex, section: 0)})
                
                totalSelectPhotoCount += 1
            }
        
            update(indexPaths: updatingIndexPaths)
            updateSelectedButton()
            
        } else {
            guard let cropVC = storyboard?.instantiateViewController(withIdentifier: "CropPhotoViewController") as? CropPhotoViewController else { return }
            
            cropVC.didFinishCropping = { image in
                self.didSelectItems?([image])
            }
            
            cropVC.originalImage = albumsManager.photos[indexPath.item].image
            self.navigationController?.pushViewController(cropVC, animated: true)
        }
    }
    
    private func update(indexPaths: [IndexPath]) {
        photoListCollectionView.performBatchUpdates {
            photoListCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    private func updateSelectedButton() {
        UIView.performWithoutAnimation {
            selectedButton.setTitle("선택하기 \(selectedPhotos.count)/\(photoKitConfig.library.maxNumberOfItems)", for: .normal)
            selectedButton.layoutIfNeeded() // 필요 시 레이아웃을 즉시 업데이트
        }
    }
}

extension PhotoKitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsManager.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        cell.photoCircleImageView.isHidden = photoKitConfig.library.defaultMultipleSelection ? false : true
        
        var target = albumsManager.photos[indexPath.row]
        let phAsset = target.phAsset
        let imageSize = CGSize(width: photoKitConfig.library.cellSize.width * photoKitConfig.library.scale, height: photoKitConfig.library.cellSize.height * photoKitConfig.library.scale)
        
        albumsManager.imageManager.requestImage(for: phAsset,
                                                targetSize: imageSize,
                                                contentMode: .aspectFill,
                                                options: nil) { image, _ in
            
            target.image = image
            self.albumsManager.photos[indexPath.row] = target
            cell.prepare(info: target)
        }
        return cell
    }
}

extension PhotoKitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoKitConfig.library.cellSize
    }
}
