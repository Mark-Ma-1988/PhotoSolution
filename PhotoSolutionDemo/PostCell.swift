//
//  PostCell.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 7/2/19.
//  Copyright © 2019 mark. All rights reserved.
//

import UIKit
import Kingfisher

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    
    private let pickerCellReuseIdentifier = "PickerCell"
    private var post: Post!
    private var cellSize: CGFloat!
    private let space = CGFloat(6)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cellSize = (photosCollectionView.frame.width - 4 * space) / 3
        cellSize = 100
        let dataCellNib = UINib(nibName: pickerCellReuseIdentifier, bundle: nil)
        photosCollectionView.register(dataCellNib, forCellWithReuseIdentifier: pickerCellReuseIdentifier)
        photosCollectionView.isScrollEnabled = false
        photosCollectionView.bounces = false
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configViewWithData(post: Post){
        self.post = post
        descriptionLabel.text = post.description
        timeLabel.text = post.time
        photosCollectionView.reloadData()
    }
}

extension PostCell: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if post == nil{
            return 0
        }else{
            return post.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize ,height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView!.dequeueReusableCell(withReuseIdentifier: pickerCellReuseIdentifier, for: indexPath) as! PickerCell
        //cell.delegate = self
        cell.tag = indexPath.row
        let photoUnit: Post.PhotoUnit = post.photos[indexPath.row]
        let imageURL = URL(string: photoUnit.compressed)
        cell.imageView.kf.setImage(with: imageURL)
        return cell
    }
}

extension PostCell: UICollectionViewDelegateFlowLayout{
    
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

extension PostCell: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
}
