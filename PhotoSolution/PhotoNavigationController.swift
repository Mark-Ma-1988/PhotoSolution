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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.performSegue(withIdentifier: "showDefaultPhotos", sender: nil)
        
    }

}
