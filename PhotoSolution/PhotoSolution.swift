//
//  PhotoSolution.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

@objc
public protocol PhotoSolutionDelegate {
    
   func returnImages(_ images: [UIImage])
   func pickerCancel()
    
}

@objc
public class PhotoSolutionCustomization: NSObject{
    
    @objc public var markerColor: UIColor = UIColor.blue
    @objc public var navigationBarBackgroundColor: UIColor = UIColor.darkGray
    @objc public var navigationBarTextColor: UIColor = UIColor.white
    @objc public var titleForAlbum: String = "Album"
    @objc public var alertTextForPhotoAccess: String = "Your App Would Like to Access Your Photos"
    @objc public var settingButtonTextForPhotoAccess: String = "Setting"
    @objc public var cancelButtonTextForPhotoAccess: String = "Cancel"
    @objc public var alertTextForCameraAccess: String = "Your App Would Like to Access the Camera"
    @objc public var settingButtonTextForCameraAccess: String = "Setting"
    @objc public var cancelButtonTextForCameraAccess: String = "Cancel"
    @objc public var returnImageSize: ReturnImageSize = .original
    @objc public var statusBarColor: StatusBarColor = .white
    
    @objc public enum ReturnImageSize: Int {
        case compressed
        case original
    }
    
    @objc public enum StatusBarColor: Int {
        case black
        case white
    }
    
}

@objc
public class PhotoSolution: NSObject{
    
    @objc public var delegate: PhotoSolutionDelegate?
    @objc public var customization = PhotoSolutionCustomization()
    var podBundle: Bundle!

    public override init(){
        let frameworkBundle = Bundle(for: PhotoSolution.self)
        let url = frameworkBundle.resourceURL!.appendingPathComponent("PhotoSolution.bundle")
        podBundle = Bundle(url: url)
    }
    
    @objc
    public func getPhotoPicker(maxPhotos: Int) -> UIViewController{

        let storyBoard = UIStoryboard(name: "PhotoStoryboard", bundle: podBundle)
        let photoNavigationController: PhotoNavigationController = storyBoard.instantiateViewController(withIdentifier: "PhotoNavigationController") as! PhotoNavigationController
        photoNavigationController.podBundle = podBundle
        photoNavigationController.solutionDelegate = self.delegate
        photoNavigationController.customization = self.customization
        photoNavigationController.maxPhotos = maxPhotos
        return photoNavigationController
    }
    
    @objc
    public func getCamera() -> UIViewController{
        let cameraNavigationController = CameraNavigationController()
        cameraNavigationController.customization = self.customization
        cameraNavigationController.solutionDelegate = self.delegate
        return cameraNavigationController
    }
    
}
