//
//  HttpLayer.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 14/2/19.
//  Copyright © 2019 mark. All rights reserved.
//

import Foundation
import Alamofire

class HttpLayer{
    
    private var basicURL: String
    let inValidJsonError = "inValidJsonError"
    let unknownError = "unknownError"
    private var headers: HTTPHeaders = [:]
    
    init(url: String) {
        basicURL = url
    }
    
    func setBasicAuth(token: String){
        headers["Authorization"] = "Bearer \(token)"
    }
    
    func setBasicAuth(user: String, password: String){
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
    }
    
    func sendMultipleFiles(_ url: String, filesData: [Data], filesFieldName: String, filesType: String, otherFields: [String:Data], successHandler: @escaping ([String: Any]) -> Void, progressHandler: @escaping (Double) -> Void, failureHandler:@escaping (String) -> Void){
        let wholeURL = "\(basicURL)\(url)"
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in otherFields {
                    multipartFormData.append(value, withName: key)
                }
                for fileData in filesData {
                    multipartFormData.append(fileData, withName: filesFieldName, fileName: "default", mimeType: filesType)
                }
        }, to: wholeURL, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    progressHandler(progress.fractionCompleted)
                })
                upload.responseJSON { response in
                    if let resultJson = response.result.value as? [String: Any]{
                        successHandler(resultJson)
                    }else
                    {
                        failureHandler(self.inValidJsonError)
                    }
                }
            case .failure(let encodingError):
                failureHandler(encodingError as! String)
            }
        }
    }
    
    func sendRequestWithAuth(_ url: String, method: HTTPMethod, parameters: [String: Any]?, successHandler: @escaping ([String: Any]) -> Void, failureHandler:@escaping (String) -> Void){
        let wholeURL = "\(basicURL)\(url)"
        Alamofire.request(wholeURL, method: method, parameters: parameters, headers: headers)
            .responseJSON { response in
                if response.result.isSuccess{
                    if let resultJson = response.result.value as? [String: Any]{
                        successHandler(resultJson)
                    }else
                    {
                        failureHandler(self.inValidJsonError)
                    }
                }else{
                    if let message=response.result.error?.localizedDescription{
                        failureHandler(message)
                    }else
                    {
                        failureHandler(self.unknownError)
                    }
                }
        }
    }
    
    func sendRequestWithoutAuth(_ wholeURL: String, method: HTTPMethod, parameters: [String: AnyObject]?, successHandler: @escaping ([String: Any]) -> Void, failureHandler:@escaping (String) -> Void){
        Alamofire.request(wholeURL, method: method, parameters: parameters)
            .responseJSON { response in
                if response.result.isSuccess{
                    if let resultJson = response.result.value as? [String: Any]{
                        successHandler(resultJson)
                    }else
                    {
                        failureHandler(self.inValidJsonError)
                    }
                }else{
                    if let message=response.result.error?.localizedDescription{
                        failureHandler(message)
                    }else
                    {
                        failureHandler(self.unknownError)
                    }
                }
        }
    }
    
}
