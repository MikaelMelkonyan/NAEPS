//
//  UIImage.swift
//  Naeps
//
//  Created by Mikael on 4/4/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit
import GPUImage

extension UIImage {
    
    func applying(contrast value: NSNumber) -> UIImage? {
        return CIImage(image: self)?.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey: value]).image
    }
    
    func applying(saturation value: NSNumber) -> UIImage? {
        return CIImage(image: self)?.applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: value]).image
    }
    
    var grayscale: UIImage? {
        return applying(saturation: 0)
    }
    
    func applying(threshold value: CGFloat) -> UIImage? {
        let imageSource = GPUImagePicture(image: self)
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = value
        imageSource?.addTarget(stillImageFilter)
        imageSource?.processImage()
        stillImageFilter.useNextFrameForImageCapture()
        let image = stillImageFilter.imageFromCurrentFramebuffer()
        return image
    }
}

extension CIImage {
    var image: UIImage? {
        let image = UIImage(ciImage: self)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: image.size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
