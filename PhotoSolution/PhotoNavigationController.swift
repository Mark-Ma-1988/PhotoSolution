//
//  PhotoNavigationController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class PhotoNavigationController: UINavigationController {
    
    var albums: [Album]?
    var solutionDelegate: PhotoSolutionDelegate?
    var maxPhotos: Int!
    var customization: PhotoSolutionCustomization!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = customization.navigationBarBackgroundColor
        self.navigationBar.tintColor = customization.navigationBarTextColor
        let textAttributes = [NSAttributedStringKey.foregroundColor: customization.navigationBarTextColor]
        self.navigationBar.titleTextAttributes = textAttributes
        self.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.performSegue(withIdentifier: "showDefaultPhotos", sender: nil)
    }
    
}
