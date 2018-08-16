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

public struct PhotoSolutionCustomization{
    
    public var markerColor: UIColor = UIColor.blue
    public var navigationBarBackgroundColor: UIColor = UIColor.darkGray
    public var navigationBarTextColor: UIColor = UIColor.white
    public var titleForAlbum: String = "Album"
    public var alertTextForPhotoAccess: String = "Your App Would Like to Access Your Photos"
    public var settingButtonTextForPhotoAccess: String = "Setting"
    public var cancelButtonTextForPhotoAccess: String = "Cancel"
    public var alertTextForCameraAccess: String = "Your App Would Like to Access the Camera"
    public var settingButtonTextForCameraAccess: String = "Setting"
    public var cancelButtonTextForCameraAccess: String = "Cancel"
    public var returnImageSize: ReturnImageSize = .original
    public var statusBarColor: StatusBarColor = .white
    
    public enum ReturnImageSize {
        case compressed
        case original
    }
    
    public enum StatusBarColor {
        case black
        case white
    }
    
}

@objc
public class PhotoSolution: NSObject{
    
    @objc public var delegate: PhotoSolutionDelegate?
    public var customization = PhotoSolutionCustomization()
    var podBundle: Bundle!

    public override init(){
        let frameworkBundle = Bundle(for: PhotoSolution.self)
        let url = frameworkBundle.resourceURL!.appendingPathComponent("PhotoSolution.bundle")
        podBundle = Bundle(url: url)
    }
    
    public func getPhotoPicker(maxPhotos: Int) -> UIViewController{

        let storyBoard = UIStoryboard(name: "PhotoStoryboard", bundle: podBundle)
        let photoNavigationController: PhotoNavigationController = storyBoard.instantiateViewController(withIdentifier: "PhotoNavigationController") as! PhotoNavigationController
        photoNavigationController.podBundle = podBundle
        photoNavigationController.solutionDelegate = self.delegate
        photoNavigationController.customization = self.customization
        photoNavigationController.maxPhotos = maxPhotos
        return photoNavigationController
    }
    
    public func getCamera() -> UIViewController{
        let cameraNavigationController = CameraNavigationController()
        cameraNavigationController.customization = self.customization
        cameraNavigationController.solutionDelegate = self.delegate
        return cameraNavigationController
    }
    
}
