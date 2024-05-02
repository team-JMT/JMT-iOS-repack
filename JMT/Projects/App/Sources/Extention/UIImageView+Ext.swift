//
//  UIImageView+Ext.swift
//  JMTeng
//
//  Created by PKW on 4/3/24.
//

import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    func setImageWithCacheCheck(urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            // URL이 유효하지 않은 경우, 플레이스홀더 이미지 설정
            self.image = placeholder
            return
        }
        
        let cache = ImageCache.default
        
        cache.retrieveImage(forKey: url.cacheKey, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    let retryStrategy = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
                    self.kf.setImage(with: url, placeholder: placeholder, options: [.retryStrategy(retryStrategy)])
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.image = placeholder
                }
            }
        }
    }
    
    // 이미지 로딩을 위한 공통 함수
    func loadImage(urlString: String?, defaultImage: UIImage) {
        if let urlString = urlString, !urlString.contains("defaultImg"), let url = URL(string: urlString) {
            self.kf.setImage(with: url)
        } else {
            self.image = defaultImage
        }
    }
}
