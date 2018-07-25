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

class PhotoSolution{
    
    var delegate:PhotoSolutionDelegate?
    
    
    func getPhotoPicker(maxPhotos: Int) -> UIViewController{
        let storyBoard = UIStoryboard(name: "PhotoStoryboard", bundle: nil)
        let photoNavigationController: PhotoNavigationController = storyBoard.instantiateViewController(withIdentifier: "PhotoNavigationController") as! PhotoNavigationController
        return photoNavigationController
    }
    
    
    
    
    
    
    
}
