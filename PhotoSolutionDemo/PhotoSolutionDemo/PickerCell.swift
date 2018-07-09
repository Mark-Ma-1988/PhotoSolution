//
//  PickerCell.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class PickerCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = UIColor.lightGray
        
    }

}
