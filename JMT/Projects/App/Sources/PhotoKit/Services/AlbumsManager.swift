//
//  AlbumsManager.swift
//  App
//
//  Created by PKW on 2024/01/12.
//

import Foundation
import Photos
import UIKit

class AlbumsManager: NSObject, PHPhotoLibraryChangeObserver {
    
    let imageManager = PHCachingImageManager()
    weak var delegate: PHPhotoLibraryChangeObserver?
    
    var albums = [AlbumInfo]()
    var photos = [PhotoInfo]()
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func fetchAlbums(completion: @escaping () -> ()) {
        
        if !albums.isEmpty {
            completion()
        }
        
        var resultAlbums = [AlbumInfo]()
        let options = PHFetchOptions()
        
        // iOS에서 자동 생성되는 앨범
        let smartAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                        subtype: .any,
                                                                        options: options)
        
        // 사용자가 생성한 앨범
        let albumsResult = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                   subtype: .any,
                                                                   options: options)
        
        for result in [smartAlbumsResult, albumsResult] {
            result.enumerateObjects { assetCollection, _, _ in
                var album = AlbumInfo()
                
                // 앨범 타이틀
                album.title = assetCollection.localizedTitle ?? ""
                
                // 앨범의 사진 수
                album.numberOfItems = self.photosCount(collection: assetCollection)
                
                if album.numberOfItems > 0 {
                    let r = PHAsset.fetchKeyAssets(in: assetCollection, options: nil)
                    if let first = r?.firstObject {
                        let deviceScale = UIScreen.main.scale
                        let targetSize = CGSize(width: 78 * deviceScale, height: 78 * deviceScale)
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        options.deliveryMode = .opportunistic
                        
                        self.imageManager.requestImage(for: first, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                            album.thumbnail = image
                        }
                    }
                    
                    album.collection = assetCollection
                    
                    // 비디오가 포함된 앨범인지 체크
                    if !(assetCollection.assetCollectionSubtype == .smartAlbumSlomoVideos || assetCollection.assetCollectionSubtype == .smartAlbumVideos) {
                        resultAlbums.append(album)
                    }
                }
            }
        }
        
        albums = resultAlbums
        completion()
    }
    
    func photosCount(collection: PHAssetCollection) -> Int {
        let options = PHFetchOptions()
        options.predicate = getPredicate()
        let result = PHAsset.fetchAssets(in: collection, options: options)
        return result.count
    }
    
    
    func albumImagesResult(index: Int, completion: @escaping () -> ()) {

        var phAssets = [PHAsset]()
        
        let options = PHFetchOptions()
        options.predicate = getPredicate()
        options.sortDescriptors = getSortDescriptors()
        
        if let collection = albums[index].collection {
            let currentAlbumFetchResult = PHAsset.fetchAssets(in: collection, options: options)
            
            guard 0 < currentAlbumFetchResult.count else { return }
            
            currentAlbumFetchResult.enumerateObjects { asset, index, stopPointer in
                guard index <= currentAlbumFetchResult.count - 1 else {
                    stopPointer.pointee = true
                    return
                }
                
                phAssets.append(asset)
            }
            
            photos = phAssets.enumerated().map { order, info in
                PhotoInfo(phAsset: info, image: nil, localIdentifier: info.localIdentifier, albumIndex: index, selectedIndex: order, selectedOrder: .none)
            }
            
            completion()
        }
    }
}


extension AlbumsManager {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        delegate?.photoLibraryDidChange(changeInstance)
    }
    
    private func getPredicate() -> NSPredicate {
        return .init(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
    }
    
    private func getSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
}

// 사진 선택시 상태 업데이트 관련
extension AlbumsManager {
    
    // 사진의 선택 상태 업데이트
    func updatePhotoSelectionState(for photo: PhotoInfo, with selectedOrder: SelectionOrder) {
            
        photos[photo.selectedIndex] = .init(phAsset: photo.phAsset, image: photo.image, localIdentifier: photo.localIdentifier, albumIndex: photo.albumIndex, selectedIndex: photo.selectedIndex, selectedOrder: selectedOrder)
    }
    
    // 선택된 사진들의 순서를 현재 앨범에 반영
    func reflectSelectedOrders(for photos: [PhotoInfo]) {
        for photo in photos {
            if case .selected(let order) = photo.selectedOrder {
                self.photos[photo.selectedIndex] = .init(phAsset: photo.phAsset, image: photo.image, localIdentifier: photo.localIdentifier, albumIndex: photo.albumIndex, selectedIndex: photo.selectedIndex, selectedOrder: .selected(order))
            }
        }
    }
}

// 선택된 사진들의 순서 재정의
extension Array where Element == PhotoInfo {
    mutating func redefineOrders() {
        for (index, var photo) in self.enumerated() {
            photo.selectedOrder = .selected(index + 1)
            self[index] = photo
        }
    }
    
    func maxSelectedOrder() -> Int {
        self.compactMap { photo -> Int? in
            if case .selected(let order) = photo.selectedOrder {
                return order
            }
            return nil
        }.max() ?? 0
    }
}
