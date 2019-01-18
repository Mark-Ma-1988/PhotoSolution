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
    var podBundle: Bundle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = customization.navigationBarBackgroundColor
        self.navigationBar.tintColor = customization.navigationBarTextColor
        let textAttributes = [NSAttributedString.Key.foregroundColor: customization.navigationBarTextColor]
        self.navigationBar.titleTextAttributes = textAttributes
        switch customization.statusBarColor {
        case .black:
            self.navigationBar.barStyle = UIBarStyle.default
        case .white:
            self.navigationBar.barStyle = UIBarStyle.blackOpaque
        }
        self.performSegue(withIdentifier: "showDefaultPhotos", sender: nil)
    }
    
}
