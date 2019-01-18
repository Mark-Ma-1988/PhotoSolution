//
//  UIImage+Extension.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 18/1/19.
//  Copyright © 2019 mark. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func rescaleImage(toPX: CGFloat) -> UIImage? {
        var size: CGSize = self.size
        if size.width <= toPX && size.height <= toPX {
            return self
        }
        let scale: CGFloat = size.width / size.height
        if size.width > size.height {
            size.width = toPX
            size.height = size.width / scale
        } else {
            size.height = toPX
            size.width = size.height * scale
        }
        return rescaleImage(to: size)
    }
    
    func rescaleImage(to size: CGSize) -> UIImage? {
        let rect: CGRect? = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext((rect?.size)!)
        draw(in: rect ?? CGRect.zero)
        let resImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resImage
    }


  
}
