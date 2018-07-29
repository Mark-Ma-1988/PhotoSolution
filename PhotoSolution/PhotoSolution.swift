//
//  PhotoSolution.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

protocol PhotoSolutionDelegate {
    func returnImages(_ images: [UIImage])
    func pickerCancel()
}

struct PhotoSolutionCustomization{
    var markerColor: UIColor = UIColor.blue
    var navigationBarBackgroundColor: UIColor = UIColor.darkGray
    var navigationBarTextColor: UIColor = UIColor.white
    var titleForAlbum: String = "Album"
    var alertTextForPhotoAccess: String = "Your App Would Like to Access Your Photos"
    var settingButtonTextForPhotoAccess: String = "Setting"
    var cancelButtonTextForPhotoAccess: String = "Cancel"
    var alertTextForCameraAccess: String = "Your App Would Like to Access the Camera"
    var settingButtonTextForCameraAccess: String = "Setting"
    var cancelButtonTextForCameraAccess: String = "Cancel"
    var returnImageSize: ReturnImageSize = .original
    var statusBarColor: StatusBarColor = .white
    
    enum ReturnImageSize {
        case compressed
        case original
    }
    
    enum StatusBarColor {
        case black
        case white
    }
}

class PhotoSolution{
    
    var delegate: PhotoSolutionDelegate?
    var customization = PhotoSolutionCustomization()
    
    func getPhotoPicker(maxPhotos: Int) -> UIViewController{
        let storyBoard = UIStoryboard(name: "PhotoStoryboard", bundle: nil)
        let photoNavigationController: PhotoNavigationController = storyBoard.instantiateViewController(withIdentifier: "PhotoNavigationController") as! PhotoNavigationController
        photoNavigationController.solutionDelegate = self.delegate
        photoNavigationController.customization = self.customization
        photoNavigationController.maxPhotos = maxPhotos
        return photoNavigationController
    }
    
    func getCamera() -> UIViewController{
        let cameraNavigationController = CameraNavigationController()
        cameraNavigationController.customization = self.customization
        cameraNavigationController.solutionDelegate = self.delegate
        return cameraNavigationController
    }
    
}
