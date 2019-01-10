//
//  ImageEditView.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 20/12/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit
import Photos

protocol ImageEditViewDelegate {
    func imageCompleted(_ editedImage: UIImage)
}

class ImageEditView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var editButton: UIImageView!
    @IBOutlet weak var saveButton: UIImageView!
    @IBOutlet weak var cancelButton: UIImageView!
   
    var podBundle: Bundle!
    var currentImage: UIImage!
    var delegate: ImageEditViewDelegate?
    
    func setupImage(edittingImage: UIImage, fromCamera: Bool){
        currentImage = edittingImage
        imageView.image = currentImage
        if fromCamera{
            setToolButtonsForCamera()
        }else{
            hideToolButtons()
        }
    }
    
    func hideToolButtons(){
        editButton.isHidden = true
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    func showToolButtons(){
        editButton.isHidden = false
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.commonInit()
//    }

//    fileprivate func commonInit() {
//    }
    
    func setToolButtonsForCamera(){
        let editGesture=UITapGestureRecognizer(target: self, action: #selector(editAction(_:)))
        editGesture.numberOfTapsRequired = 1
        editButton.isUserInteractionEnabled = true
        editButton.addGestureRecognizer(editGesture)
        
        let cancelGesture=UITapGestureRecognizer(target: self, action: #selector(cancelAction(_:)))
        cancelGesture.numberOfTapsRequired = 1
        cancelButton.isUserInteractionEnabled = true
        cancelButton.addGestureRecognizer(cancelGesture)
        
        let saveGesture=UITapGestureRecognizer(target: self, action: #selector(saveAction(_:)))
        saveGesture.numberOfTapsRequired = 1
        saveButton.isUserInteractionEnabled = true
        saveButton.addGestureRecognizer(saveGesture)
        
    }
    
    @objc private func editAction(_ gesture: UITapGestureRecognizer) {
        
    }
    
    @objc private func cancelAction(_ gesture: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    @objc private func saveAction(_ gesture: UITapGestureRecognizer) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self.currentImage)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                DispatchQueue.main.async{
                    self.delegate?.imageCompleted(self.currentImage)
                }
            } else{
                print("save fail", error!.localizedDescription)
            }
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
