//
//  PhotoKitViewController.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import UIKit

class PhotoKitViewController: UIViewController {
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumArrowImageView: UIImageView!
    @IBOutlet weak var albumListView: UIView!
    @IBOutlet weak var albumListTableView: UITableView!
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    @IBOutlet weak var multipleSelectionButtonStackView: UIStackView!
    @IBOutlet weak var albumListViewBottomConstraint: NSLayoutConstraint!
    
    var didSelectItems: ((UIImage?) -> Void)?
    
    let albumsManager = AlbumsManager()
    
    var isAnimating = false
    var currentAlbumIndex: Int = 0 {
        didSet {
            albumsManager.albumImagesResult(index: currentAlbumIndex) {
                self.setAlbumTitle(self.albumsManager.albums[self.currentAlbumIndex])
                DispatchQueue.main.async {
                    self.photoListCollectionView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        albumsManager.fetchAlbums {
            self.albumsManager.albumImagesResult(index: self.currentAlbumIndex) {
                self.setAlbumTitle(self.albumsManager.albums[self.currentAlbumIndex])
            }
        }
    }
    
    @IBAction func didTabCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTabAlbumTitleButton(_ sender: Any) {
        updateAlbumTableViewConstraints()
    }
    
    func setupUI() {
        if photoKitConfig.library.defaultMultipleSelection {
            multipleSelectionButtonStackView.isHidden = false
        } else {
            multipleSelectionButtonStackView.isHidden = true
        }
    }
    
    func updateAlbumTableViewConstraints() {
        guard !isAnimating else { return }
        
        isAnimating = true
        NSLayoutConstraint.deactivate([albumListViewBottomConstraint])
        
        albumListViewBottomConstraint = albumListView.frame.height == 0.0
        ? albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
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
            // 사진 선택 여러개 
        } else {
            // 사진 선택 하나만
            guard let cropVC = storyboard?.instantiateViewController(withIdentifier: "CropPhotoViewController") as? CropPhotoViewController else { return }

            cropVC.didFinishCropping = { image in
                self.didSelectItems?(image)
            }
            
            cropVC.originalImage = albumsManager.photos[indexPath.item].image ?? UIImage()
            self.navigationController?.pushViewController(cropVC, animated: true)
        }
    }
}

extension PhotoKitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsManager.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        
        var target = albumsManager.photos[indexPath.row]
        let phAsset = target.phAsset
        let imageSize = CGSize(width: photoKitConfig.library.cellSize.width * photoKitConfig.library.scale, height: photoKitConfig.library.cellSize.height * photoKitConfig.library.scale)
        
        albumsManager.imageManager.requestImage(for: phAsset,
                                                targetSize: imageSize,
                                                contentMode: .aspectFill,
                                                options: nil) { image, _ in
            
            target.image = image
            self.albumsManager.photos[indexPath.row] = target
            
            
            cell.prepare(info: PhotoInfo(phAsset: phAsset, image: image, selectedOrder: target.selectedOrder))
        }
        
        return cell
    }
}

extension PhotoKitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoKitConfig.library.cellSize
    }
}




//class PhotoKitViewController: UIViewController {
//
//    @IBOutlet weak var albumChangeButton: UIButton!
//    @IBOutlet weak var albumListView: UIView!
//    @IBOutlet weak var albumListTableView: UITableView!
//    @IBOutlet weak var photoListCollectionView: UICollectionView!
//    @IBOutlet weak var multipleSelectionButtonStackView: UIStackView!
//    @IBOutlet weak var albumListViewBottomConstraint: NSLayoutConstraint!
//
//    var viewModel: AlbumViewModel?
//    var isAnimating = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        viewModel?.onCompletedAlbum = { [weak self] update in
//            switch update {
//            case .albumTableView:
//                self?.updateAlbumTableViewConstraints()
//            default:
//                return
//            }
//        }
//
//        viewModel?.onCompletedPhoto = { [weak self] update, indexPaths in
//            switch update {
//            case .photoCollectionView:
//                self?.photoListCollectionView.reloadData()
//            case .photoCell:
//                self?.photoListCollectionView.performBatchUpdates {
//                    self?.photoListCollectionView.reloadItems(at: indexPaths)
//                }
//            default:
//                return
//            }
//        }
//
//        setupUI()
//        viewModel?.fetchAlbums() {
//            DispatchQueue.main.async {
//                self.albumChangeButton.setTitle(self.viewModel?.getAlbumTitle() ?? "", for: .normal)
//                self.viewModel?.fetchPhotoAssets()
//            }
//        }
//    }
//
//    func setupUI() {
//        // 다중선택 시 버튼 활성화
//        if photoKitConfig.library.defaultMultipleSelection {
//            multipleSelectionButtonStackView.isHidden = false
//        } else {
//            multipleSelectionButtonStackView.isHidden = true
//        }
//    }
//
//    @IBAction func didTabCloseButton(_ sender: Any) {
//        dismiss(animated: true)
//    }
//
//    @IBAction func didTabAlbumTitleButton(_ sender: Any) {
//        viewModel?.fetchAlbumAsset()
//    }
//
//    func updateAlbumTableViewConstraints() {
//        guard !isAnimating else { return }
//
//        isAnimating = true
//        NSLayoutConstraint.deactivate([albumListViewBottomConstraint])
//
//        albumListViewBottomConstraint = albumListView.frame.height == 0.0
//        ? albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
//        : albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
//
//        NSLayoutConstraint.activate([albumListViewBottomConstraint])
//
//        UIView.animate(withDuration: 0.5) {
//            self.view.layoutIfNeeded()
//        } completion: { _ in
//            self.isAnimating = false
//            self.albumListTableView.reloadData()
//        }
//    }
//}
//
//extension PhotoKitViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.albums.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumCell else { return UITableViewCell() }
//
//        if let target = viewModel?.albums[indexPath.row],
//           let phAsset = target.phAsset {
//            let imageSize = CGSize(width: 55, height: 55)
//
//            viewModel?.photoService?.fetchImage(phAsset: phAsset, size: imageSize, contentMode: .aspectFit, completion: { image in
//                let newAlbumInfo = AlbumInfo(id: target.id,
//                                             name: target.name,
//                                             count: target.count,
//                                             album: target.album,
//                                             phAsset: phAsset,
//                                             thumbnail: image)
//                cell.prepare(info: newAlbumInfo)
//            })
//        }
//
//        return cell
//    }
//}
//
//extension PhotoKitViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel?.currentAlbunIndex = indexPath.row
//        albumChangeButton.setTitle(viewModel?.getAlbumTitle() ?? "", for: .normal)
//        updateAlbumTableViewConstraints()
//    }
//}
//
/////
//extension PhotoKitViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel?.photos.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
//
//        if let target = viewModel?.photos[indexPath.item] {
//            let phAsset = target.phAsset
//            let imageSize = CGSize(width: photoKitConfig.library.cellSize.width * photoKitConfig.library.scale, height: photoKitConfig.library.cellSize.height * photoKitConfig.library.scale)
//
//            viewModel?.photoService?.fetchImage(phAsset: phAsset,
//                                                size: imageSize,
//                                                contentMode: .aspectFit,
//                                                completion: { image in
//                cell.prepare(info: PhotoInfo(phAsset: phAsset, image: image, selectedOrder: target.selectedOrder))
//            })
//        }
//
//        return cell
//    }
//}
//
//extension PhotoKitViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if photoKitConfig.library.defaultMultipleSelection {
//            viewModel?.updatePhotoSelectionStatus(indexPath: indexPath)
//        } else {
//            print("123123")
//        }
//    }
//}
//
//extension PhotoKitViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return photoKitConfig.library.cellSize
//    }
//}
