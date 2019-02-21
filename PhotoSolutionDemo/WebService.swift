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
    
    struct Constants {
        static let baseURL = "https://www.boltdelivery.com.au/new/photoSolution"
    }
    
    var httpLayer: HttpLayer
    
    static let shared = WebService(httpLayer: HttpLayer(url: Constants.baseURL))
    
    private init(httpLayer: HttpLayer) {
        self.httpLayer = httpLayer
        //httpLayer.setBasicAuth(user: "Mark", password: "Ma")
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
            }else
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
    
    func getPost(lastPostID: Int, successHandler: @escaping ([Post],Bool) -> Void, failureHandler:@escaping (String) -> Void){
        
        let timeZone = TimeZone.current.identifier
        let urlPath = "/photos/lastPostID/\(lastPostID)/timeZone/\(timeZone)"
        
        httpLayer.sendRequestWithAuth(urlPath, method: .get, parameters: nil, successHandler: { json in
            if (json["status"] as? String) == "success"{
                do{
                    let postArray = try JSONDecoder().decode([Post].self, from:  JSONSerialization.data(withJSONObject: json["data"]!, options: []))
                    let hasMoreData = json["hasMoreData"] as! Bool
                    successHandler(postArray,hasMoreData)
                }catch let error{
                    print(error.localizedDescription)
                }
            }else
            {
                failureHandler(json["data"] as! String)
            }
        }) { error in
            failureHandler(error)
        }
    }
    
    
}
