//
//  ViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var pickedPhotoCollectionView: UICollectionView!
    var cellSize: CGFloat!
    let pickerCellReuseIdentifier = "PickerCell"
    let space = CGFloat(8)
    var currentImages: [UIImage] = [UIImage]()
    let maxPhotos = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellSize = (pickedPhotoCollectionView.frame.width-4*space)/3
        let dataCellNib = UINib(nibName: pickerCellReuseIdentifier, bundle: nil)
        pickedPhotoCollectionView.register(dataCellNib, forCellWithReuseIdentifier: pickerCellReuseIdentifier)
        pickedPhotoCollectionView.isScrollEnabled = true
        pickedPhotoCollectionView.bounces = false
        pickedPhotoCollectionView.reloadData()
    }
    
    func calulateImageFileSize(_ image: UIImage?) {
        var data: Data? = image!.pngData()
        var dataLength = Double((data?.count ?? 0)) * 1.0
        let typeArray = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
        var index: Int = 0
        while dataLength > 1024 {
            dataLength /= 1024.0
            index += 1
        }
        print("image = \(dataLength) \(typeArray[index]) ")
    }
    
    func getPhotos() {
        let photoSolution = PhotoSolution()
        photoSolution.delegate = self
        photoSolution.customization.markerColor = UIColor.blue
        photoSolution.customization.navigationBarBackgroundColor = UIColor.darkGray
        photoSolution.customization.navigationBarTextColor = UIColor.white
        photoSolution.customization.titleForAlbum = "Album"
        photoSolution.customization.alertTextForPhotoAccess = "Your App Would Like to Access Your Photos"
        photoSolution.customization.settingButtonTextForPhotoAccess = "Setting"
        photoSolution.customization.cancelButtonTextForPhotoAccess = "Cancel"
        photoSolution.customization.alertTextForCameraAccess = "Your App Would Like to Access Your Photos"
        photoSolution.customization.settingButtonTextForCameraAccess = "Setting"
        photoSolution.customization.cancelButtonTextForCameraAccess = "Cancel"
        photoSolution.customization.returnImageSize = .compressed
        photoSolution.customization.statusBarColor = .white
        
        var alertController: UIAlertController
        if UIDevice.current.userInterfaceIdiom == .phone{
            alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        }else{
            alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        }
        let takeAction = UIAlertAction(title: "Take a photo", style: .default, handler: { action in
            self.present(photoSolution.getCamera(), animated: true, completion: nil)
        })
        let findAction = UIAlertAction(title: "From my album", style: .default, handler: { action in
            let remainPhotos = self.maxPhotos - self.currentImages.count
            self.present(photoSolution.getPhotoPicker(maxPhotos: remainPhotos), animated: true, completion: nil)
        })
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        })
        alertController.addAction(takeAction)
        alertController.addAction(findAction)
        alertController.addAction(cancleAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendClick(_ sender: UIBarButtonItem) {
        
    }
    
    
}


extension PostViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentImages.count < maxPhotos{
            return currentImages.count + 1
        }else{
            return maxPhotos
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize ,height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pickedPhotoCollectionView!.dequeueReusableCell(withReuseIdentifier: pickerCellReuseIdentifier, for: indexPath) as! PickerCell
        cell.delegate = self
        cell.tag = indexPath.row
        if indexPath.row == currentImages.count{
            cell.imageView.image = UIImage(named: "addIcon")
            cell.deleteIcon.isHidden = true
        }else{
            cell.imageView.image = currentImages[indexPath.row]
            cell.deleteIcon.isHidden = false
        }
        return cell
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return space
    }
    
}

extension PostViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.row == currentImages.count{
            getPhotos()
        }
    }
}

extension PostViewController: PickerCellDelegate{
    
    func deleteClick(_ cell: UICollectionViewCell) {
        currentImages.remove(at: cell.tag)
        pickedPhotoCollectionView.reloadData()
    }
    
}

extension PostViewController: PhotoSolutionDelegate{

    func returnImages(_ images: [UIImage]) {
        for image in images {
            if currentImages.count < maxPhotos{
                currentImages.append(image)
            }
        }
        calulateImageFileSize(images.first)
        pickedPhotoCollectionView.reloadData()
    }
    
    func pickerCancel() {
        print("User close it!")
    }
    
}
