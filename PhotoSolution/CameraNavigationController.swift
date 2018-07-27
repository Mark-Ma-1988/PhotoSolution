//
//  CameraNavigationController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit
import Photos

class CameraNavigationController: UINavigationController {
    
    var cameraViewController: UIImagePickerController?
    var solutionDelegate:PhotoSolutionDelegate?
    var customization: PhotoSolutionCustomization!
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
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    self.hasOpen = true
                    self.present(self.cameraViewController!, animated: false, completion: nil)
                } else {
                    self.goToCameraAccessSetting()
                }
            }
        }
    }
    
    func goToCameraAccessSetting(){
        let alert = UIAlertController(title: nil, message: self.customization.alertTextForCameraAccess, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: self.customization.settingButtonTextForCameraAccess, style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        }))
        alert.addAction( UIAlertAction(title: self.customization.cancelButtonTextForCameraAccess, style: .default, handler: { action in
            self.solutionDelegate?.pickerCancel()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
