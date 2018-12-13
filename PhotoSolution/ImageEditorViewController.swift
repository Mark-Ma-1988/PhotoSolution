//
//  ImageEditorViewController.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 25/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController {
    
    @IBOutlet weak var statusCoverView: UIView!
    @IBOutlet weak var clickButton: UIBarButtonItem!
    @IBOutlet weak var topNavigationBar: UINavigationBar!
    private var imageCollectionView: UICollectionView?
    private let navigationBarHeight = CGFloat(40)
    var currentPhotoList = [Photo]()
    var currentIndex: Int?
    private let imageCellReuseIdentifier = "ImageViewCell"
    var customization: PhotoSolutionCustomization!
    var podBundle: Bundle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setupBars()
        setupImageCollectionView()
        NotificationCenter.default.addObserver(self, selector:#selector(orientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientation() {
        if imageCollectionView != nil{
            imageCollectionView!.isHidden = true
            imageCollectionView!.dataSource = nil
            imageCollectionView!.delegate = nil
            imageCollectionView = nil
            setupImageCollectionView()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupBars(){
        clickButton.tintColor = customization.navigationBarTextColor
        topNavigationBar.barTintColor = customization.navigationBarBackgroundColor
    }
    
    private func setupImageCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.view.frame.size
        flowLayout.scrollDirection = .horizontal
        imageCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        self.view.addSubview(imageCollectionView!)
        self.view.sendSubviewToBack(imageCollectionView!)
        //imageCollectionView!.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraint(NSLayoutConstraint(item: imageCollectionView!, attribute: .leading, relatedBy: .equal, toItem: self.view , attribute: .leading, multiplier: 1, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: imageCollectionView!, attribute: .trailing, relatedBy: .equal, toItem: self.view , attribute: .trailing, multiplier: 1, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: imageCollectionView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: imageCollectionView!, attribute: .bottom, relatedBy: .equal, toItem: self.view , attribute: .bottom, multiplier: 1, constant: 0))
        
        let dataCellNib = UINib(nibName: imageCellReuseIdentifier, bundle: podBundle)
        imageCollectionView!.register(dataCellNib, forCellWithReuseIdentifier: imageCellReuseIdentifier)
        imageCollectionView!.isScrollEnabled = true
        imageCollectionView!.backgroundColor = UIColor.black
        imageCollectionView!.delegate = self
        imageCollectionView!.dataSource = self
        imageCollectionView!.isPagingEnabled = true
        imageCollectionView!.reloadData()
        //imageCollectionView!.layoutIfNeeded()
        imageCollectionView!.scrollToItem(at: IndexPath(item: currentIndex!, section: 0), at: .centeredHorizontally, animated: false)
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
        return imageCollectionView!.frame.size
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
        if let lastTag = imageCollectionView?.visibleCells.first?.tag{
            currentIndex = lastTag
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
}
