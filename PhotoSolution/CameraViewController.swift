//
//  CameraViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 13/12/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {

    var solutionDelegate:PhotoSolutionDelegate?
    var customization: PhotoSolutionCustomization!
    
    @IBAction func closeButtonClick(_ sender: UIBarButtonItem) {
        self.solutionDelegate?.pickerCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rotateButtonClick(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }


}
