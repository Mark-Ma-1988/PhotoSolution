//
//  PhotoVC.swift
//  NG POC
//
//  Created by MA XINGCHEN on 30/6/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit
import Photos

protocol PhotoViewControllerDelegate {
    func returnImages(_ images: [UIImage])
    func pickerCancel()
}

class PhotoViewController: UIViewController {
    
    var delegate:PhotoViewControllerDelegate?
    var backgroundColor: UIColor = UIColor.white
    var maxAmount = 9
    
    private var albums = [Album]()
    private var currentPhotoList = [Photo]()
    private var currentSelectedPhotoList = [Photo]()
    private let navigationBarHeight = CGFloat(40)
    private var safeAreaBottomHeight: CGFloat!
    private var safeAreaTopHeight: CGFloat!
    private var topNavigationBar: UINavigationBar!
    private var topNavigationItem: UINavigationItem!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    private var photoCollection: UICollectionView!
    private var cellSize: CGFloat!
    private let photoCellReuseIdentifier = "PhotoCell"
    private let space = CGFloat(2.5)
    private var bottomNavigationBar: UINavigationBar!
    private var bottomNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            safeAreaTopHeight = window!.safeAreaInsets.top
            safeAreaBottomHeight = window!.safeAreaInsets.bottom
        }else{
            safeAreaTopHeight = 0
            safeAreaBottomHeight = 0
        }
        
        if safeAreaTopHeight == 0{
            safeAreaTopHeight = UIApplication.shared.statusBarFrame.height
        }
        
        setupTopNavigationBar()
        setupCollectionView()
        setupBottomNavigationBar()
        self.activityIndicator.startAnimating()
        getPhotos()
    }
    
    private func setupTopNavigationBar(){
        
        topNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: safeAreaTopHeight, width: self.view.frame.width, height: navigationBarHeight))
        topNavigationBar.barTintColor = backgroundColor
        topNavigationBar.isTranslucent = false
        self.view.addSubview(topNavigationBar);
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelClick))
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneClick))
        doneItem.isEnabled = false
        topNavigationItem = UINavigationItem(title: "");
        topNavigationItem.leftBarButtonItem = cancelItem
        topNavigationItem.rightBarButtonItem = doneItem
        
        topNavigationBar.setItems([topNavigationItem], animated: false);
    }
    
    private func setupCollectionView(){
        
        cellSize = (self.view.frame.width-5*space)/4
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowLayout.scrollDirection = .vertical
        photoCollection = UICollectionView(frame: CGRect(x: 0, y: topNavigationBar.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height-(navigationBarHeight+safeAreaBottomHeight+navigationBarHeight+safeAreaTopHeight)), collectionViewLayout: flowLayout)
        self.view.addSubview(photoCollection!)
        let dataCellNib = UINib(nibName: photoCellReuseIdentifier, bundle: nil)
        photoCollection.register(dataCellNib, forCellWithReuseIdentifier: photoCellReuseIdentifier)
        photoCollection.isScrollEnabled = true
        photoCollection.backgroundColor = UIColor.white
        photoCollection.delegate = self
        photoCollection.dataSource = self
        
        activityIndicator.center = photoCollection.center
        self.view.addSubview(activityIndicator)
    }
    
    private func setupBottomNavigationBar(){
        
        let bottomNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: photoCollection!.frame.maxY, width: self.view.frame.size.width, height: navigationBarHeight))
        bottomNavigationBar.barTintColor = backgroundColor
        bottomNavigationBar.isTranslucent = false
        bottomNavigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bottomNavigationBar.shadowImage = UIImage()
        self.view.addSubview(bottomNavigationBar)

        let bottomNavigationItem = UINavigationItem(title: "");
        bottomNavigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize, target: self, action: #selector(albumClick))
        bottomNavigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(cameraClick))
        bottomNavigationBar.setItems([bottomNavigationItem], animated: false);
    }
    
    
    private func getPhotos(){
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                var maxPhotoAmount = 0
                var maxPhotoAmountIndex = 0
                collections.enumerateObjects { (collection, idx, stop) in
                    let album = Album(collection: collection)
                    let photoAmount = album.getPhotoCount()
                    if photoAmount > 0
                    {
                        self.albums.append(album)
                        if photoAmount > maxPhotoAmount{
                            maxPhotoAmountIndex = self.albums.count - 1
                            maxPhotoAmount = photoAmount
                        }
                    }
                }
                self.showPhotoCollection(index: maxPhotoAmountIndex)
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func showPhotoCollection(index: Int){
        self.currentPhotoList = self.albums[index].getPhotos()
        DispatchQueue.main.async{
        self.topNavigationItem.title = self.albums[index].getAlbumName()
        self.photoCollection!.reloadData()
        let lastIndexPath = IndexPath(item: self.currentPhotoList.count-1, section: 0)
        self.photoCollection!.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
        self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func albumClick(){
        let albumViewControler = AlbumViewController()
        albumViewControler.albums = albums
        albumViewControler.delegate = self
        albumViewControler.backgroundColor = self.backgroundColor
        self.present(albumViewControler, animated: true, completion: nil)
    }
    
    @objc func cameraClick(){
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.delegate = self
        cameraPickerController.sourceType = .camera
        self.present(cameraPickerController, animated: true, completion: nil)
    }
    
    @objc func cancelClick(){
        delegate?.pickerCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneClick(){
        
        
    }
    
}

extension PhotoViewController: UICollectionViewDataSource{
    
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
        let cell = photoCollection!.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as! PhotoCell
        cell.configViewWithData(phone: currentPhotoList[indexPath.row])
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout{
    
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

extension PhotoViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let imageViewController = ImageViewController()
        imageViewController.currentPhotoList = currentPhotoList
        imageViewController.currentIndex = indexPath.row
        imageViewController.backgroundColor = backgroundColor
        self.present(imageViewController, animated: false, completion: nil)
    }
    
}

extension PhotoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
            let doneItem = topNavigationItem.rightBarButtonItem
            doneItem?.isEnabled = true
            delegate?.returnImages([newImage])
        }
        picker.dismiss(animated: true) {
            self.dismiss(animated: false, completion: {
                
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewController: AlbumViewControllerDelegate{
    func selectAlbum(_ selectedindex: Int) {
        showPhotoCollection(index: selectedindex)
    }
}

extension PhotoViewController: PhotoCellDelegate{
    func cellClick(_ cell: UICollectionViewCell) {
        let clickedPhoto = currentPhotoList[cell.tag]
        if clickedPhoto.selected{
            clickedPhoto.selected = false
            photoCollection.reloadItems(at: [IndexPath(item: cell.tag, section: 0)])
            currentSelectedPhotoList.remove(at: clickedPhoto.selectedOrder - 1)
            if clickedPhoto.selectedOrder < currentSelectedPhotoList.count + 1{
                for index in clickedPhoto.selectedOrder-1...currentSelectedPhotoList.count-1 {
                    currentSelectedPhotoList[index].selectedOrder = index + 1
                }
                let indexPaths = currentSelectedPhotoList.map ({ element -> IndexPath in
                    return IndexPath(item: element.index, section: 0)
                })
                photoCollection.reloadItems(at: indexPaths)
            }
        }else if currentSelectedPhotoList.count < maxAmount{
            currentSelectedPhotoList.append(clickedPhoto)
            clickedPhoto.selected = true
            clickedPhoto.selectedOrder = currentSelectedPhotoList.count
            photoCollection.reloadItems(at: [IndexPath(item: cell.tag, section: 0)])
        }else{
            print("send alert")
        }
    }
}


