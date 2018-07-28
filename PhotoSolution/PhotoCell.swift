//
//  PhotoCell.swift
//  NG POC
//
//  Created by MA XINGCHEN on 2/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate {
    func cellClick(_ cell: UICollectionViewCell)
}

class PhotoCell: UICollectionViewCell {
    
    private var photo: Photo?
    private var markerColor: UIColor?
    var delegate: PhotoCellDelegate?
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var clickArea: UIView!
    private let thumbnailSize = CGFloat(200)
    
    func configViewWithData(photo: Photo){
        self.photo = photo
        self.photo!.getThumbnail(size: thumbnailSize) { image in
            self.imageView.image = image
        }
        if self.photo!.selected{
            select(number: self.photo!.selectedOrder, animation: numberLabel.isHidden)
        }else{
            disSelect()
        }
        
    }
    
    func select(number: Int, animation: Bool){
        numberLabel.text = "\(number)"
        tickImage.isHidden = true
        if animation{
            UIView.animate(withDuration: 0.5, animations: {
                self.numberLabel.isHidden = false
            }) { finished in
                
            }
        }else{
            numberLabel.isHidden = false
        }
    }
    
    func disSelect(){
        numberLabel.isHidden = true
        tickImage.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tickGesture=UITapGestureRecognizer(target: self, action: #selector(tickThisCell(_:)))
        tickGesture.numberOfTapsRequired = 1
        clickArea.isUserInteractionEnabled = true
        clickArea.addGestureRecognizer(tickGesture)
        numberLabel.layer.cornerRadius = numberLabel.frame.size.width/2
        numberLabel.layer.masksToBounds = true
        if let color = markerColor{
            numberLabel.backgroundColor = color
        }
    }
    
    @objc private func tickThisCell(_ gesture: UITapGestureRecognizer) {
        self.delegate?.cellClick(self)
    }
}
