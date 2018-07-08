//
//  PhotoCell.swift
//  NG POC
//
//  Created by MA XINGCHEN on 2/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var clickArea: UIView!
    private let thumbnailSize = CGFloat(200)
    
    func configViewWithData(phone: Photo){
        phone.getThumbnail(size: thumbnailSize) { image in
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
    

}
