//
//  ViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        pickedPhotoCollectionView.backgroundColor = UIColor.white
        pickedPhotoCollectionView.reloadData()
    }
}


extension ViewController: UICollectionViewDataSource{
    
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

extension ViewController: UICollectionViewDelegateFlowLayout{
    
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

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.row == currentImages.count{
            let photoSolution = PhotoSolution()
            photoSolution.delegate = self
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
    }
}

extension ViewController: PickerCellDelegate{
    
    func deleteClick(_ cell: UICollectionViewCell) {
        currentImages.remove(at: cell.tag)
        pickedPhotoCollectionView.reloadData()
    }
    
}

extension ViewController: PhotoSolutionDelegate{
    func returnImages(_ images: [UIImage]) {
        for image in images {
            if currentImages.count < maxPhotos{
                currentImages.append(image)
            }
        }
        pickedPhotoCollectionView.reloadData()
    }
    
    func pickerCancel() {
    }
}
