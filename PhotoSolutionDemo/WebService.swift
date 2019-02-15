//
//  WebService.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 14/2/19.
//  Copyright © 2019 mark. All rights reserved.
//

import Foundation
import Alamofire

class WebService{
    
    static let shared = WebService(httpLayer: HttpLayer(url: "https://www.boltdelivery.com.au/new/photoSolution"))
    
    var httpLayer: HttpLayer
    
    private init(httpLayer: HttpLayer) {
        self.httpLayer = httpLayer
    }
    
    func uploadPost(description: String, photos: [UIImage], successHandler: @escaping () -> Void, progressHandler: @escaping (Float) -> Void, failureHandler:@escaping (String) -> Void){
        
        let urlPath = "/photos"
        let paramater = ["description" : description.data(using: String.Encoding.utf8)!]
        var photosDataArray = Array<Data>()
        for photo in photos {
            photosDataArray.append(photo.pngData()!)
        }
        httpLayer.sendMultipleFiles(urlPath, filesData: photosDataArray, filesFieldName: "photos", filesType: "image/png", otherFields: paramater, successHandler: { json in
            if (json["status"] as? String) == "success"{
                successHandler()
            }
            else
            {
                failureHandler(json["data"] as! String)
            }
        }, progressHandler: {progress in
            progressHandler(Float(progress))
        },
           failureHandler: { error in
            failureHandler(error)
        })
    }
    
    
}
