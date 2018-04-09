//
//  UISegmentedControl.swift
//  Naeps
//
//  Created by Mikael on 4/9/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.white), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor ?? UIColor.blue), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: tintColor ?? UIColor.blue), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

