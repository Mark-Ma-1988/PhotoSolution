//
//  Album.swift
//  NG POC
//
//  Created by MA XINGCHEN on 2/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import Foundation
import Photos

class Album{
    
    private var collection: PHAssetCollection
    private var options:PHFetchOptions
    
    init(collection: PHAssetCollection) {
        self.collection = collection
        options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
    }
    
    func getAlbumName() -> String{
        if let name = collection.localizedTitle{
            return name
        }else{
            return "???"
        }
        
    }
    
    func getPhotos() -> [Photo]{
        let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(in: collection, options: options)
        var photoList = [Photo]()
        assetsFetchResults.enumerateObjects({ asset, idx, stop in
            photoList.append(Photo(asset: asset))
        })
        return photoList
    }
    
    func getPhotoCount() -> Int{
        let collectionResult = PHAsset.fetchAssets(in: collection, options: options)
        return collectionResult.count
    }
    
    func getPosterPhoto(posterSize: CGFloat,callback: @escaping (UIImage) -> Void) {
        let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(in: collection, options: options)
        let firstPhoto = Photo(asset: assetsFetchResults.firstObject!)
        firstPhoto.getThumbnail(size: posterSize) { image in
            callback(image)
        }
    }
    
}
