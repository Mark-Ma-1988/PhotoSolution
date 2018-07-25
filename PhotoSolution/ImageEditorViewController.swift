//
//  ImageEditorViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController {
    
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    private let statusCoverView = UIView()
    private let navigationBarHeight = CGFloat(40)
    private var safeAreaTopHeight: CGFloat!
    var currentPhotoList = [Photo]()
    var currentIndex: Int?
    private let imageCellReuseIdentifier = "ImageViewCell"
    private var screenHeight: CGFloat!
    private var screenWidth: CGFloat!
    private let topAlpha = CGFloat(0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBars()
        setupImageCollectionView()
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//            //super.viewWillTransition(to: size, with: coordinator)
//            if UIDevice.current.orientation.isLandscape {
//                
//                cellWidth = (UIApplication.shared.keyWindow?.height)!/3
//            } else {
//                
//                cellWidth = (UIApplication.shared.keyWindow?.height)!/3
//            }
//            imageCollectionView.reloadData()
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupBars(){
        let window = UIApplication.shared.keyWindow!
        screenHeight = window.frame.height
        screenWidth = window.frame.width
        if #available(iOS 11.0, *) {
            safeAreaTopHeight = window.safeAreaInsets.top
        }else{
            safeAreaTopHeight = 0
        }
        if safeAreaTopHeight == 0{
            safeAreaTopHeight = UIApplication.shared.statusBarFrame.height
        }
        statusCoverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: UIApplication.shared.statusBarFrame.height)
        self.view.addSubview(statusCoverView)
        statusCoverView.backgroundColor = UIColor.darkGray
        statusCoverView.alpha = topAlpha
        topNavigationBar.alpha = topAlpha
        topNavigationBar.frame = CGRect(x: 0, y: safeAreaTopHeight, width: screenWidth, height: navigationBarHeight)
        
    }
    
    private func setupImageCollectionView(){
        imageCollectionView.frame = self.view.frame
        let dataCellNib = UINib(nibName: imageCellReuseIdentifier, bundle: nil)
        imageCollectionView.register(dataCellNib, forCellWithReuseIdentifier: imageCellReuseIdentifier)
        imageCollectionView.backgroundColor = UIColor.black
        imageCollectionView.reloadData()
        imageCollectionView.scrollToItem(at: IndexPath(item: currentIndex!, section: 0), at: .left, animated: false)
        imageCollectionView.isPagingEnabled = true
    }
    
    @IBAction func closeClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ImageEditorViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth ,height: screenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView!.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageViewCell
        cell.configViewWithData(phone: currentPhotoList[indexPath.row])
        return cell
    }
}

extension ImageEditorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}

extension ImageEditorViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        topNavigationBar.isHidden = !self.topNavigationBar.isHidden
        statusCoverView.isHidden = !self.statusCoverView.isHidden
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
