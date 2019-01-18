//
//  AlbumCell.swift
//  NG POC
//
//  Created by MA XINGCHEN on 2/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    private let posterSize = CGFloat(200)
    
    func configViewWithData(album: Album){
        album.getPosterPhoto(posterSize: posterSize) {image in
            self.poster.image = image
        }
        nameLabel.text = album.getAlbumName()
        amountLabel.text = "(\(album.getPhotoCount()))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
