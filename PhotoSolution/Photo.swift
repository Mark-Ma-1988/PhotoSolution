//
//  Photo.swift
//  NG POC
//
//  Created by MA XINGCHEN on 1/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import Foundation
import Photos

class Photo{
    
    private var asset: PHAsset
    var selected = false
    var selectedOrder: Int = 0
    var index: Int!
    let compressedSize = 1000
    
    init(asset: PHAsset,index: Int) {
        self.asset = asset
        self.index = index
    }
    
    func isImage() -> Bool{
        return asset.mediaType == PHAssetMediaType.image
    }
    
    func getOriginalImage(callback: @escaping (UIImage) -> Void) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (originImage, info) in
            callback(originImage!)
        }
    }
    
    func getCompressedImage(callback: @escaping (UIImage) -> Void) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.resizeMode = .fast
        manager.requestImage(for: asset, targetSize: CGSize.init(width: compressedSize, height: compressedSize), contentMode: .aspectFit, options: option) { (originImage, info) in
            callback(originImage!)
        }
    }
    
    func getThumbnail(size: CGFloat, callback: @escaping (UIImage) -> Void){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .highQualityFormat
        manager.requestImage(for: asset, targetSize: CGSize.init(width: size, height: size), contentMode: .aspectFit, options: option) { (thumbnailImage, info) in
            callback(thumbnailImage!)
        }
    }
    
}
