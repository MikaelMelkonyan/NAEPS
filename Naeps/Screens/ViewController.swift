//
//  ViewController.swift
//  Naeps
//
//  Created by Mikael on 4/4/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var processed: UIImageView!
    @IBOutlet var status: UILabel!
    
    private var heatMap: IBHeatMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processed.image = UIImage(named: "step_1")
        status.text = "Loading"
    }
    
    @objc func addPointToHeatMap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let point = sender.location(in: sender.view)
        let relativePoint = CGPoint(x: point.x / view.frame.size.width, y: point.y / view.frame.size.height)
        heatMap.points.append(relativePoint)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if heatMap == nil {
            createHeatMap()
            drawHeatMap()
        }
    }
    
    private func createHeatMap() {
        let x = processed.frame.minX
        let y = processed.frame.minY
        heatMap = IBHeatMap(frame: CGRect(x: x, y: y, width: processed.frame.width, height: processed.frame.height))
        heatMap.colors = [UIColor.green, UIColor.yellow, UIColor.red]
        heatMap.pointRadius = 20
        heatMap.alpha = 0.5
        heatMap.delegate = self
        view.addSubview(heatMap)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPointToHeatMap(_:)))
        heatMap.addGestureRecognizer(tapGesture)
    }
    
    private func drawHeatMap() {
        let width = processed.frame.size.width
        let height = processed.frame.size.height
        background {
            let image = UIImage(named: "step_3")!
            let points = self.getWhitePoints(in: image, width: width, height: height)
//            var points = [CGPoint]()
//            for x in 1...10 {
//                for y in 1...10 {
//                    points.append(CGPoint(x: CGFloat(x) / 10, y: CGFloat(y) / 10))
//                }
//            }
            print(points.count)
            main {
                self.heatMap.points = points
            }
        }
    }
}

extension ViewController: IBHeatMapDelegate {
    
    func heatMapFinishedLoading() {
        print("Finally")
    }
}

extension ViewController {
    
//    func drawDots(on image: UIImage, for points: [CGPoint], dotColor: UIColor) -> UIImage? {
//        UIGraphicsBeginImageContext(image.size)
//        // draw original image into the context
//        image.draw(at: CGPoint.zero)
//
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//
//        context.setFillColor(dotColor.cgColor)
//        for point in points {
//            let rect = CGRect(x: point.x, y: point.y, width: 150, height: 150)
//            context.fillEllipse(in: rect)
//        }
//
//        context.strokePath()
//        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resultImage
//    }
    
    func getWhitePoints(in image: UIImage, width: CGFloat, height: CGFloat) -> [CGPoint] {
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
                    whitePoints.append(CGPoint(x: CGFloat(x) / width, y: CGFloat(y) / height))
                }
            }
        }
        return whitePoints
    }
}
