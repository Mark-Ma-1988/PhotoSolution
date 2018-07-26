//
//  PhotoCollectionViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewController: UIViewController {
    
    @IBOutlet weak var bottomNavigationBar: UINavigationBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var selectedAlbumIndex: Int?
    private var photoNavigationController: PhotoNavigationController!
    private var albums: [Album]?
    private var maxAmount = 9
    private var currentPhotoList = [Photo]()
    private var currentSelectedPhotoList = [Photo]()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    private var cellSize: CGFloat!
    private let photoCellReuseIdentifier = "PhotoCell"
    private let space = CGFloat(2.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoNavigationController = self.navigationController as! PhotoNavigationController
        maxAmount = photoNavigationController.maxPhotos
        bottomNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bottomNavigationBar.shadowImage = UIImage()
        doneButton.tintColor = photoNavigationController.customization.navigationBarTextColor
        self.view.backgroundColor = photoNavigationController.customization.navigationBarBackgroundColor
        bottomNavigationBar.barTintColor = photoNavigationController.customization.navigationBarBackgroundColor
        
        setupCollectionView()
        if let albums = photoNavigationController.albums{
            self.albums = albums
            showPhotoCollection()
        }else{
            getPhotos()
        }
    }
    
    private func setupCollectionView(){
        cellSize = (self.view.frame.width-5*space)/4
        let dataCellNib = UINib(nibName: photoCellReuseIdentifier, bundle: nil)
        photoCollectionView.register(dataCellNib, forCellWithReuseIdentifier: photoCellReuseIdentifier)
        activityIndicator.center = photoCollectionView.center
        self.view.addSubview(activityIndicator)
    }
    
    private func getPhotos(){
        activityIndicator.startAnimating()
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                var maxPhotoAmount = 0
                var maxPhotoAmountIndex = 0
                self.albums = [Album]()
                collections.enumerateObjects { (collection, idx, stop) in
                    let album = Album(collection: collection)
                    let photoAmount = album.getPhotoCount()
                    if photoAmount > 0
                    {
                        self.albums!.append(album)
                        if photoAmount > maxPhotoAmount{
                            maxPhotoAmountIndex = self.albums!.count - 1
                            maxPhotoAmount = photoAmount
                        }
                    }
                }
                self.photoNavigationController.albums = self.albums
                self.selectedAlbumIndex = maxPhotoAmountIndex
                self.showPhotoCollection()
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func showPhotoCollection(){
        self.currentSelectedPhotoList.removeAll()
        self.currentPhotoList = self.albums![selectedAlbumIndex!].getPhotos()
        DispatchQueue.main.async{
            self.title = self.albums![self.selectedAlbumIndex!].getAlbumName()
            self.photoCollectionView.reloadData()
            let lastIndexPath = IndexPath(item: self.currentPhotoList.count-1, section: 0)
            self.photoCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func cancelClick(_ sender: UIBarButtonItem) {
        photoNavigationController.solutionDelegate?.pickerCancel()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClick(_ sender: UIBarButtonItem) {
        var resultImages = [UIImage]()
        for photo in currentSelectedPhotoList{
            photo.getOriginalImage { image in
                resultImages.append(image)
            }
        }
        photoNavigationController.solutionDelegate?.returnImages(resultImages)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            if let imageEditorViewController = segue.destination as? ImageEditorViewController {
                let selectedIndex = sender as! Int
                imageEditorViewController.currentPhotoList = currentPhotoList
                imageEditorViewController.currentIndex = selectedIndex
                imageEditorViewController.customization = photoNavigationController.customization
            }
        }
    }
}

extension PhotoCollectionViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize ,height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as! PhotoCell
        cell.numberLabel.backgroundColor = photoNavigationController.customization.markerColor
        cell.configViewWithData(phone: currentPhotoList[indexPath.row])
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout{
    
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

extension PhotoCollectionViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "showPhoto", sender: indexPath.row)
    }
    
}

extension PhotoCollectionViewController: PhotoCellDelegate{
    
    func cellClick(_ cell: UICollectionViewCell) {
        let clickedPhoto = currentPhotoList[cell.tag]
        if clickedPhoto.selected{
            clickedPhoto.selected = false
            photoCollectionView.reloadItems(at: [IndexPath(item: cell.tag, section: 0)])
            currentSelectedPhotoList.remove(at: clickedPhoto.selectedOrder - 1)
            if clickedPhoto.selectedOrder < currentSelectedPhotoList.count + 1{
                for index in clickedPhoto.selectedOrder-1...currentSelectedPhotoList.count-1 {
                    currentSelectedPhotoList[index].selectedOrder = index + 1
                }
                let indexPaths = currentSelectedPhotoList.map ({ element -> IndexPath in
                    return IndexPath(item: element.index, section: 0)
                })
                photoCollectionView.reloadItems(at: indexPaths)
            }
        }else if currentSelectedPhotoList.count < maxAmount{
            currentSelectedPhotoList.append(clickedPhoto)
            clickedPhoto.selected = true
            clickedPhoto.selectedOrder = currentSelectedPhotoList.count
            photoCollectionView.reloadItems(at: [IndexPath(item: cell.tag, section: 0)])
        }else{
            print("send alert")
        }
        if currentSelectedPhotoList.count > 0{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
    }
    
}
