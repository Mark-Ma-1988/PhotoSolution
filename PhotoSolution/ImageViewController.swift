//
//  ImageViewController.swift
//  NG POC
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var currentPhotoList = [Photo]()
    var currentIndex: Int = 0
    var customiseTitle: String = ""
    var backgroundColor: UIColor = UIColor.lightGray
    
    private let space = CGFloat(20)
    private let navigationBarHeight = CGFloat(40)
    private var safeAreaBottomHeight: CGFloat!
    private var safeAreaTopHeight: CGFloat!
    private var topNavigationBar: UINavigationBar!
    private var topNavigationItem: UINavigationItem!
    private var screenHeight: CGFloat!
    private var screenWidth: CGFloat!
    private var imageViewCollection: UICollectionView!
    private let imageCellReuseIdentifier = "ImageViewCell"
    private let statusCoverView = UIView()
    private let topAlpha = CGFloat(0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        let window = UIApplication.shared.keyWindow!
        if #available(iOS 11.0, *) {
            safeAreaTopHeight = window.safeAreaInsets.top
        }else{
            safeAreaTopHeight = 0
        }
        if safeAreaTopHeight == 0{
            safeAreaTopHeight = UIApplication.shared.statusBarFrame.height
        }
        screenHeight = window.frame.height
        screenWidth = window.frame.width
        setupImageViewCollection()
        setupTopNavigationBar()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupTopNavigationBar(){
        statusCoverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: UIApplication.shared.statusBarFrame.height)
        self.view.addSubview(statusCoverView)
        statusCoverView.backgroundColor = backgroundColor
        statusCoverView.alpha = topAlpha
        
        topNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: safeAreaTopHeight, width: screenWidth, height: navigationBarHeight))
        topNavigationBar.barTintColor = backgroundColor
        topNavigationBar.isTranslucent = false
        self.view.addSubview(topNavigationBar);
        let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(backClick))
        topNavigationItem = UINavigationItem(title: customiseTitle);
        topNavigationItem.leftBarButtonItem = backItem
        topNavigationBar.setItems([topNavigationItem], animated: false);
        topNavigationBar.alpha = topAlpha
    }

    private func setupImageViewCollection(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: screenWidth, height: screenHeight)
        flowLayout.scrollDirection = .horizontal
        imageViewCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.view.addSubview(imageViewCollection!)
        let dataCellNib = UINib(nibName: imageCellReuseIdentifier, bundle: nil)
        imageViewCollection.register(dataCellNib, forCellWithReuseIdentifier: imageCellReuseIdentifier)
        imageViewCollection.isScrollEnabled = true
        imageViewCollection.backgroundColor = UIColor.black
        imageViewCollection.delegate = self
        imageViewCollection.dataSource = self
        imageViewCollection.reloadData()
        imageViewCollection.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        imageViewCollection.isPagingEnabled = true
    }
    
    @objc func backClick(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewController: UICollectionViewDataSource{
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
        let cell = imageViewCollection!.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageViewCell
        cell.configViewWithData(photo: currentPhotoList[indexPath.row])
        return cell
    }
}

extension ImageViewController: UICollectionViewDelegateFlowLayout{
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

extension ImageViewController: UICollectionViewDelegate{
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



