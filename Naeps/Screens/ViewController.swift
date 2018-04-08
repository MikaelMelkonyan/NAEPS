//
//  ViewController.swift
//  Naeps
//
//  Created by Mikael on 4/4/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var original: UIImageView!
    @IBOutlet var processed: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        original.image = UIImage(named: "step_1")

//        var image = UIImage(named: "image")?.applying(saturation: 0)
//        image = image?.applying(contrast: 0.97)
//        processed.image = image
        
        if let image = UIImage(named: "step_3") {
            background {
                let points = self.getWhitePoints(in: image)
                let resultImage = self.drawDots(on: UIImage(named: "step_1")!, for: points, dotColor: UIColor(hex: 0xff6600, alpha: 0.03))
                main {
                    self.processed.image = resultImage
                }
            }
        }
    }
    
    func getWhitePoints(in image: UIImage) -> [CGPoint] {
        let pixelsWidth = Int(image.size.width)
        let pixelsHeight = Int(image.size.height)
        
        let pixelData = image.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var whitePoints = [CGPoint]()
        for x in 0..<pixelsWidth {
            for y in 0..<pixelsHeight {
                let pixelInfo: Int = ((pixelsWidth * Int(y)) + Int(x)) * 4
                let r = data[pixelInfo]
                let g = data[pixelInfo+1]
                let b = data[pixelInfo+2]
                let a = data[pixelInfo+3]
                
                if r == 255 && g == 255 && b == 255 && a == 255 {
                    whitePoints.append(CGPoint(x: x, y: y))
                }
            }
        }
        return whitePoints
    }
    
    func drawDots(on image: UIImage, for points: [CGPoint], dotColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        // draw original image into the context
        image.draw(at: CGPoint.zero)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(dotColor.cgColor)
        for point in points {
            let rect = CGRect(x: point.x, y: point.y, width: 150, height: 150)
            context.fillEllipse(in: rect)
        }
        
        context.strokePath()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}

