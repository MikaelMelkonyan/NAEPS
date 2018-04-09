//
//  UIView.swift
//  Naeps
//
//  Created by Mikael on 4/9/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

extension UIView {
    
    func crop(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    
    func addGradient(colors: (UIColor, UIColor), isHorizontal: Bool = false, crop: CGFloat? = nil) {
        if let gradientSubLayer = self.layer.sublayers?.first as? CAGradientLayer {
            gradientSubLayer.colors = [colors.0.cgColor, colors.1.cgColor]
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [colors.0.cgColor, colors.1.cgColor]
            if isHorizontal {
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            if let crop = crop {
                gradientLayer.cornerRadius = crop
                gradientLayer.masksToBounds = false
            }
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func rotate360(duration: CFTimeInterval = 1.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
