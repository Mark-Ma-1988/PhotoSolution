//
//  CameraNavigationController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class CameraNavigationController: UINavigationController {

    var cameraViewController: UIImagePickerController?
    var solutionDelegate:PhotoSolutionDelegate?
    private var hasOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.navigationBar.barTintColor = UIColor.black
        self.navigationBar.isTranslucent = false
        cameraViewController = UIImagePickerController()
        cameraViewController!.delegate = self
        cameraViewController!.sourceType = .camera
        cameraViewController!.allowsEditing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if !hasOpen{
            hasOpen = true
            self.present(cameraViewController!, animated: false, completion: nil)
        }
    }

}

extension CameraNavigationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
            solutionDelegate?.returnImages([newImage])
            cameraViewController?.dismiss(animated: false, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        solutionDelegate?.pickerCancel()
        cameraViewController?.dismiss(animated: false, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
