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
    var alertTextForPhotoAccess: String = "The text to access photo"
    var alertTextForCameraUsage: String = "The text to use camera"
    var titleForAlbum: String = "Album"
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
        cameraNavigationController.solutionDelegate = self.delegate
        return cameraNavigationController
    }
    
}
