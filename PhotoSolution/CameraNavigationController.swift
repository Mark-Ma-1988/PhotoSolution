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
        cameraViewController?.cameraFlashMode = .off
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if !hasOpen{
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            self.hasOpen = true
                            self.present(self.cameraViewController!, animated: false, completion: nil)
                        case .denied, .restricted:
                            self.goToPhotoAccessSetting()
                        case .notDetermined:
                            self.goToPhotoAccessSetting()
                        }
                    }
                } else {
                    self.goToCameraAccessSetting()
                }
            }
        }
    }
    
    func goToPhotoAccessSetting(){
        let alert = UIAlertController(title: nil, message: customization.alertTextForPhotoAccess, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: customization.settingButtonTextForPhotoAccess, style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        alert.addAction( UIAlertAction(title: customization.cancelButtonTextForPhotoAccess, style: .default, handler: { action in
            self.solutionDelegate?.pickerCancel()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToCameraAccessSetting(){
        let alert = UIAlertController(title: nil, message: self.customization.alertTextForCameraAccess, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: self.customization.settingButtonTextForCameraAccess, style: .cancel, handler: { action in
            UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        }))
        alert.addAction( UIAlertAction(title: self.customization.cancelButtonTextForCameraAccess, style: .default, handler: { action in
            self.solutionDelegate?.pickerCancel()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension CameraNavigationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var localId: String = ""
        if let newImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            PHPhotoLibrary.shared().performChanges({
                let result = PHAssetChangeRequest.creationRequestForAsset(from: newImage)
                let assetPlaceholder = result.placeholderForCreatedAsset!
                localId = assetPlaceholder.localIdentifier
            }) { (isSuccess: Bool, error: Error?) in
                if isSuccess {
                    let assetResult = PHAsset.fetchAssets(
                        withLocalIdentifiers: [localId], options: nil)
                    let photo = Photo(asset: assetResult[0], index: 0)
                    if self.customization.returnImageSize == .compressed{
                        photo.getCompressedImage(callback: { image in
                            DispatchQueue.main.async{
                                self.solutionDelegate?.returnImages([image])
                                self.cameraViewController?.dismiss(animated: false, completion: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                        })
                    }else{
                        photo.getOriginalImage(callback: { image in
                            DispatchQueue.main.async{
                                self.solutionDelegate?.returnImages([image])
                                self.cameraViewController?.dismiss(animated: false, completion: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                        })
                    }
                } else{
                    print("save fail", error!.localizedDescription)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        solutionDelegate?.pickerCancel()
        cameraViewController?.dismiss(animated: false, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
