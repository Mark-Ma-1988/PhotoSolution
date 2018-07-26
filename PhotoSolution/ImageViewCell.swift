//
//  ImageViewCell.swift
//  NG POC
//
//  Created by MA XINGCHEN on 8/7/18.
//  Copyright © 2018 mark. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    private let maxZoom = CGFloat(3)
    
    func configViewWithData(phone: Photo){
        self.imageView.transform.a = 1
        self.imageView.transform.d = 1
        //        self.imageView.transform.tx = 0
        //        self.imageView.transform.ty = 0
        phone.getOriginalImage { image in
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchView(_:)))
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        //        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panView(_:)))
        //        imageView.addGestureRecognizer(panGestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        
    }
    
    //    @objc func panView(_ panGestureRecognizer: UIPanGestureRecognizer) {
    //        let view = panGestureRecognizer.view!
    //        if view.transform.a > 1 && view.transform.d > 1{
    //            if panGestureRecognizer.state == .began || panGestureRecognizer.state == .changed {
    //                let translation = panGestureRecognizer.translation(in: view.superview)
    //                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
    //                panGestureRecognizer.setTranslation(CGPoint.zero, in: view.superview)
    //            }
    //        }
    //    }
    
    @objc func pinchView(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        let view = pinchGestureRecognizer.view!
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            view.transform = view.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale)
            pinchGestureRecognizer.scale = 1
        }else if pinchGestureRecognizer.state == .ended{
            if view.transform.a < 1 || view.transform.d < 1{
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.transform.a = 1
                    self.imageView.transform.d = 1
                }) { finished in
                }
            }else if view.transform.a > maxZoom || view.transform.d > maxZoom{
                UIView.animate(withDuration: 0.5, animations: {
                    self.imageView.transform.a = self.maxZoom
                    self.imageView.transform.d = self.maxZoom
                }) { finished in
                }
            }
            
        }
    }
}
