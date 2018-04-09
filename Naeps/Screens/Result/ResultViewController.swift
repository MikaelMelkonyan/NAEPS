//
//  ViewController.swift
//  Naeps
//
//  Created by Mikael on 4/4/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var processed: UIImageView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    private var heatMap: UIImageView!
    private var points: [CGPoint]?
    private var weights: [Int]?
    
    private var dotsMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage(named: "step_1")!
        processed.image = image
        changeRatio(for: image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if heatMap == nil {
            createHeatMap()
            createDotsMap()
            drawMaps()
        }
    }
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        guard let points = points, let weights = weights else { return }
        let heatMapImage = LFHeatMap.heatMap(with: self.processed.frame, boost: sender.value, points: points, weights: weights)
        heatMap.image = heatMapImage
    }
    
    @IBAction func segmentDidChange(_ sender: UISegmentedControl) {
        heatMap.isHidden = !(sender.selectedSegmentIndex == 0)
        dotsMap.isHidden = sender.selectedSegmentIndex == 0
    }
    
    private func createHeatMap() {
        heatMap = UIImageView(frame: processed.frame)
        view.addSubview(heatMap)
    }
    
    private func createDotsMap() {
        dotsMap = UIImageView(frame: processed.frame)
        view.addSubview(dotsMap)
        dotsMap.isHidden = true
    }
    
    private func drawMaps() {
        let start = processed.frame.minY
        let width = processed.frame.size.width
        let height = processed.frame.size.height
        background {
            let image = UIImage(named: "step_3")!
            let (points, weights) = self.getWhitePoints(in: image, width: width, height: height, yStart: start)
            self.points = points
            self.weights = weights
            main {
                self.slider.isUserInteractionEnabled = true
                let heatMapImage = LFHeatMap.heatMap(with: self.processed.frame, boost: self.slider.value, points: points, weights: weights)
                self.heatMap.image = heatMapImage
                
                let dotsMapImage = self.drawDots(on: UIImage(named: "step_1")!, for: points, width: width, height: height, yStart: start)
                self.dotsMap.image = dotsMapImage
            }
        }
    }
}

extension ResultViewController {
    
    func drawDots(on image: UIImage, for points: [CGPoint], width: CGFloat, height: CGFloat, yStart: CGFloat) -> UIImage? {
        let pixelsWidth = CGFloat(image.size.width)
        let pixelsHeight = CGFloat(image.size.height)
        UIGraphicsBeginImageContext(image.size)
        // draw original image into the context
        image.draw(at: CGPoint.zero)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let dotColor = UIColor(hex: 0xFFA500, alpha: 0.2)
        context.setFillColor(dotColor.cgColor)
        for point in points {
            let rect = CGRect(x: point.x / width * pixelsWidth, y: (point.y - yStart) / height * pixelsHeight, width: 150, height: 150)
            context.fillEllipse(in: rect)
        }

        context.strokePath()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func getWhitePoints(in image: UIImage, width: CGFloat, height: CGFloat, yStart: CGFloat) -> ([CGPoint], [Int]) {
        let pixelsWidth = Int(image.size.width)
        let pixelsHeight = Int(image.size.height)
        
        let pixelData = image.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var whitePoints = [CGPoint]()
        var weights = [Int]()
        for x in 0..<pixelsWidth {
            for y in 0..<pixelsHeight {
                let pixelInfo: Int = ((pixelsWidth * Int(y)) + Int(x)) * 4
                let r = data[pixelInfo]
                let g = data[pixelInfo+1]
                let b = data[pixelInfo+2]
                let a = data[pixelInfo+3]
                
                if r == 255 && g == 255 && b == 255 && a == 255 {
                    let point = CGPoint(x: (CGFloat(x) / CGFloat(pixelsWidth)) * width, y: (CGFloat(y) / CGFloat(pixelsHeight)) * height + yStart)
                    whitePoints.append(point)
                    weights.append(1)
                }
            }
        }
        return (whitePoints, weights)
    }
}

// MARK: Helpers
extension ResultViewController {
    
    private func setupView() {
        title = "Результати обробки"
        view.addGradient(colors: (UIColor(hex: 0x008975), UIColor(hex: 0x00BF9A)))
        setupNavBar()
        setupSlider()
        setupSegmentedControl()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = UIColor.white
        navBar.barStyle = .black
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .medium)]
    }
    
    private func changeRatio(for image: UIImage) {
        let height = (image.size.height * processed.frame.width) / image.size.width
        imageHeight.constant = height
        view.layoutIfNeeded()
    }
    
    private func setupSlider() {
        slider.value = 0.5
        slider.isUserInteractionEnabled = false
    }
    
    private func setupSegmentedControl() {
        let font = UIFont.systemFont(ofSize: 15, weight: .light)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        segmentedControl.crop(radius: segmentedControl.frame.height / 2)
        segmentedControl.removeBorders()
        segmentedControl.setBorder(width: 1, color: UIColor.white)
        
        segmentedControl.setTitle("Heat Map", forSegmentAt: 0)
        segmentedControl.setTitle("Dots Map", forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = 0
    }
}
