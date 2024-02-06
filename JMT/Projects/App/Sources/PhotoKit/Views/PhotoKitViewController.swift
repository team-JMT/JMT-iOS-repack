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
    @IBOutlet weak var selectedButtonView: UIView!
    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var hiddenViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var albumListViewBottomConstraint: NSLayoutConstraint!
    
    var didSelectItems: (([PhotoInfo]) -> Void)?
    
    let albumsManager = AlbumsManager()
    var selectedIndexArray = [Int]()
    var selectedPhotos = [PhotoInfo]()
    
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
        
        albumsManager.fetchAlbums {
            self.albumsManager.albumImagesResult(index: self.currentAlbumIndex) {
                self.setAlbumTitle(self.albumsManager.albums[self.currentAlbumIndex])
                self.updateSelectedImages()
            }
        }
    
        setupUI()
        
        NSLayoutConstraint.deactivate([albumListViewBottomConstraint])
        albumListViewBottomConstraint = albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([albumListViewBottomConstraint])
        
        hiddenViewHeightConstraint.constant = Utils.safeAreaBottomInset()
    }
    
    @IBAction func didTabCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTabAlbumTitleButton(_ sender: Any) {
        selectedIndexArray.removeAll()
        selectedPhotos.removeAll()
        updateAlbumTableViewConstraints()
    }
    
    func setupUI() {
        
        selectedButton.setTitle("선택하기 \(selectedPhotos.count)/10", for: .normal)
        
        if photoKitConfig.library.defaultMultipleSelection {
            photoCountView.isHidden = false
            selectedButtonView.isHidden = false
        } else {
            photoCountView.isHidden = true
            selectedButtonView.isHidden = true
        }
    }
    
    func updateSelectedImages() {
        if !self.selectedPhotos.isEmpty {
            
            var order = 1
            
            for selectedPhoto in self.selectedPhotos {
                if let index = self.albumsManager.photos.firstIndex(where: { $0.localIdentifier == selectedPhoto.localIdentifier }) {
                    
                    self.selectedIndexArray.append(index)
                    
                    let info = self.albumsManager.photos[index]
                    self.albumsManager.photos[index] = .init(phAsset: info.phAsset, image: info.image, localIdentifier: info.localIdentifier, selectedOrder: .selected(order))
                    
                    order += 1
                }
            }
            
            self.photoListCollectionView.reloadData()
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
        self.didSelectItems?(selectedPhotos)
        
        print(" ---- ", selectedIndexArray)
        
        dismiss(animated: true)
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
            let info = albumsManager.photos[indexPath.item]
            let updatingIndexPaths: [IndexPath]
        
            if selectedPhotos.count >= photoKitConfig.library.maxNumberOfItems && info.selectedOrder == SelectionOrder.none {
                // 사용자에게 경고 메시지 표시
                print("선택 불가")
                return
            }
            
            if case .selected = info.selectedOrder {
                albumsManager.photos[indexPath.item] = .init(phAsset: info.phAsset, image: info.image, localIdentifier: info.localIdentifier, selectedOrder: .none)
            
                selectedPhotos.removeAll(where: { $0.localIdentifier == info.localIdentifier })
                selectedIndexArray.removeAll(where: { $0 == indexPath.item })

                selectedIndexArray
                    .enumerated()
                    .forEach { order, index in
                        let order = order + 1
                        let prev = albumsManager.photos[index]
                        albumsManager.photos[index] = .init(phAsset: prev.phAsset, image: prev.image, localIdentifier: prev.localIdentifier, selectedOrder: .selected(order))
                    }
                updatingIndexPaths = [indexPath] + selectedIndexArray.map { IndexPath(row: $0, section: 0) }
            } else {
                selectedIndexArray.append(indexPath.item)
                selectedPhotos.append(albumsManager.photos[indexPath.item])
            
                selectedIndexArray
                    .enumerated()
                    .forEach { order, selectedIndex in
                        let order = order + 1
                        let prev = albumsManager.photos[selectedIndex]
                        albumsManager.photos[selectedIndex] = .init(phAsset: prev.phAsset, image: prev.image, localIdentifier: prev.localIdentifier, selectedOrder: .selected(order))
                    }
                
                updatingIndexPaths = selectedIndexArray.map { IndexPath(row: $0, section: 0) }
            }
            
            update(indexPaths: updatingIndexPaths)
            updateSelectedButton()
            
        } else {
            // 사진 선택 하나만
            guard let cropVC = storyboard?.instantiateViewController(withIdentifier: "CropPhotoViewController") as? CropPhotoViewController else { return }

            cropVC.didFinishCropping = { image in
                self.didSelectItems?([image])
            }
            
            cropVC.originalImage = albumsManager.photos[indexPath.item]
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
            selectedButton.setTitle("선택하기 \(selectedPhotos.count)/10", for: .normal)
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
            
            
            cell.prepare(info: PhotoInfo(phAsset: phAsset, image: image, localIdentifier: target.localIdentifier, selectedOrder: target.selectedOrder))
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
