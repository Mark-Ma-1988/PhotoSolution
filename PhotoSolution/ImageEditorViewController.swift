//
//  ImageEditorViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController {
    
    @IBOutlet weak var clickButton: UIBarButtonItem!
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
    var customization: PhotoSolutionCustomization!
    private var lastShowIndex: IndexPath?
    private let window = UIApplication.shared.keyWindow!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBars()
        setupImageCollectionView()
        NotificationCenter.default.addObserver(self, selector:#selector(orientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        lastShowIndex = IndexPath(item: currentIndex!, section: 0)
        setupFrameAndLoadData()
    }
    
    @objc func orientation() {
        setupFrameAndLoadData()
    }
    
    private func setupFrameAndLoadData(){
        if UIDevice.current.orientation.isPortrait {
            if #available(iOS 11.0, *) {
                safeAreaTopHeight = window.safeAreaInsets.top
            }else{
                safeAreaTopHeight = UIApplication.shared.statusBarFrame.height
            }
            statusCoverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: safeAreaTopHeight)
            topNavigationBar.frame = CGRect(x: 0, y: safeAreaTopHeight, width: screenWidth, height: navigationBarHeight)
            imageCollectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }else{
            if #available(iOS 11.0, *) {
                safeAreaTopHeight = window.safeAreaInsets.top
            }else{
                safeAreaTopHeight = 0
            }
            statusCoverView.frame = CGRect(x: 0, y: 0, width: screenHeight, height: safeAreaTopHeight)
            topNavigationBar.frame = CGRect(x: 0, y: safeAreaTopHeight, width: screenHeight, height: navigationBarHeight)
            imageCollectionView.frame = CGRect(x: (screenHeight/2-screenWidth/2), y: 0, width: screenHeight, height: screenWidth)
//            imageCollectionView.frame.size = CGSize(width: screenHeight, height: screenWidth)
            imageCollectionView.center.x = screenHeight/2
//            imageCollectionView.frame.origin.y = 0
            
        }
        imageCollectionView.reloadData()
        imageCollectionView.scrollToItem(at: lastShowIndex!, at: .centeredHorizontally, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupBars(){
        screenHeight = window.frame.height
        screenWidth = window.frame.width
        
        self.view.addSubview(statusCoverView)
        statusCoverView.backgroundColor = customization.navigationBarBackgroundColor
        statusCoverView.alpha = topAlpha
        topNavigationBar.alpha = topAlpha
        clickButton.tintColor = customization.navigationBarTextColor
        topNavigationBar.barTintColor = customization.navigationBarBackgroundColor
    }
    
    private func setupImageCollectionView(){
        let dataCellNib = UINib(nibName: imageCellReuseIdentifier, bundle: nil)
        imageCollectionView.register(dataCellNib, forCellWithReuseIdentifier: imageCellReuseIdentifier)
        imageCollectionView.backgroundColor = UIColor.black
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
        if UIDevice.current.orientation.isPortrait {
            return CGSize(width: screenWidth, height: screenHeight)
        }else{
            return CGSize(width: screenHeight, height: screenWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView!.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageViewCell
        cell.configViewWithData(photo: currentPhotoList[indexPath.row])
        cell.tag = indexPath.row
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if let lastTag = imageCollectionView.visibleCells.first?.tag{
            lastShowIndex = IndexPath(item: lastTag, section: 0)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
 
}
