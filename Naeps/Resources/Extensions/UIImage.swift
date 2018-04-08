//
//  UIImage.swift
//  Naeps
//
//  Created by Mikael on 4/4/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

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
