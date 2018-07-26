//
//  PickerCell.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

protocol PickerCellDelegate {
    func deleteClick(_ cell: UICollectionViewCell)
}

class PickerCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var delegate: PickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = UIColor.lightGray
        let tickGesture=UITapGestureRecognizer(target: self, action: #selector(deleteThisCell(_:)))
        tickGesture.numberOfTapsRequired = 1
        deleteIcon.isUserInteractionEnabled = true
        deleteIcon.addGestureRecognizer(tickGesture)
    }
    
    @objc private func deleteThisCell(_ gesture: UITapGestureRecognizer) {
        self.delegate?.deleteClick(self)
    }
    
}
