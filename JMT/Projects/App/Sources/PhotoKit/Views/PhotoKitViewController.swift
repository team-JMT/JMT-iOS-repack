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

    var selectedPhotos = [PhotoInfo]()
    
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
                self.updateSelectedImages()
            }
        }
    
        setupUI()
        
        NSLayoutConstraint.deactivate([albumListViewBottomConstraint])
        albumListViewBottomConstraint = albumListView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        NSLayoutConstraint.activate([albumListViewBottomConstraint])
        
        hiddenViewHeightConstraint.constant = Utils.safeAreaBottomInset()
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
        
        if !selectedPhotos.isEmpty {
            
            let currentAlbumPhotos = selectedPhotos.filter { $0.albumIndex == currentAlbumIndex }
            
            for photo in currentAlbumPhotos {
                albumsManager.photos[photo.selectedIndex] = photo
            }
        }
    }
    
    func test() {
        if !selectedPhotos.isEmpty {
            
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
           
            // 사진 여러장 선택시
            
            // 선택한 사진 정보
            var info = albumsManager.photos[indexPath.item]
           
            // 업데이트할 인덱스 패스 배열
            let updatingIndexPaths: [IndexPath]
        
            // 선택 가능한 최대 항목 수를 초과했는지 검사
            if selectedPhotos.count >= photoKitConfig.library.maxNumberOfItems && info.selectedOrder == SelectionOrder.none {
                print("선택 불가")  // 사용자에게 경고 메시지 표시
                return
            }
            
            // 이미 선택한 사진의 선택을 취소하는 경우
            if case .selected = info.selectedOrder {

                // 사진 선택 상태 업데이트
                albumsManager.updatePhotoSelectionState(for: info, with: .none)
                
                // 선택한 사진 삭제
                selectedPhotos.removeAll(where: { $0.localIdentifier == info.localIdentifier })
            
                // 선택한 사진 순서
                selectedPhotos.redefineOrders()
                
                // 현재 앨범의 선택된 사진들만 필터링
                let currentAlbumPhotos = selectedPhotos.filter({ $0.albumIndex == currentAlbumIndex })
                
                // 현재 앨범의 선택된 사진들의 순서를 albumsManager에 반영
                albumsManager.reflectSelectedOrders(for: currentAlbumPhotos)
            
                updatingIndexPaths = [indexPath] + currentAlbumPhotos.map({ IndexPath(row: $0.selectedIndex, section: 0)})
            } else {
                
                // 선택된 순서의 최댓값
                let maxOrder = selectedPhotos.maxSelectedOrder()
                
                // 선택된 사진의 순서
                info.selectedOrder = .selected(maxOrder + 1)
                
                // 선택된 사진 배열에 추가
                selectedPhotos.append(info)
            
                // 현재 앨범에 포함된 사진
                let currentAlbumPhotos = selectedPhotos.filter({ $0.albumIndex == currentAlbumIndex })
                
                albumsManager.updatePhotoSelectionState(for: info, with: .selected(maxOrder + 1))
                
                updatingIndexPaths = currentAlbumPhotos.map({ IndexPath(row: $0.selectedIndex, section: 0)})
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
