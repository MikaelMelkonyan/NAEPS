//
//  IBHeatMap.swift
//  Naeps
//
//  Created by Mikael on 4/8/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import UIKit

class IBHeatMap: UIView {
    
    private let colors: [UIColor]
    private let pointRadius: CGFloat
    
    private var points = [CGPoint]()
    private var delegate: IBHeatMapDelegate?
    
    private var colorMatrix: IBMatrix?
    private var densityMatrix: IBMatrix?
    
    init(frame: CGRect, 
         colors: [UIColor] = [UIColor.green, UIColor.yellow, UIColor.red],
         pointRadius: CGFloat = 20) {
        self.colors = colors
        self.pointRadius = pointRadius
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        redrawView()
    }
    
    func setPoints(_ points: [CGPoint]) {
        self.points = points
        redrawView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Logic
extension IBHeatMap {
    
    private func redrawView() {
        let boundsValue = self.bounds
        background {
            self.calculatePixelColors(in: boundsValue)
            main {
                self.delegate?.heatMapFinishedLoading()
                self.setNeedsDisplay()
            }
        }
    }
}

// MARK: Pixel Calculator
extension IBHeatMap {
    
    private func calculatePixelColors(in bounds: CGRect) {
        let maxDensity = maxDensityCalc(in: bounds)
        let columns = Int(bounds.width)
        let lines = Int(bounds.height)
        
        let matrix = IBMatrix(columns: columns, lines: lines)
        for x in 0..<columns {
            for y in 0..<lines {
                let density = densityMatrix!.object(forColumn: x, line: y) as! CGFloat
                let color = color(for: density, maxDensity: maxDensity)
                matrix?.setObject(color, column: x, line: y)
            }
        }
        colorMatrix = matrix
    }
}

// MARK: Helpers
extension IBHeatMap {
    
    private func maxDensityCalc(in bounds: CGRect) -> CGFloat {
        let columns = Int(bounds.width)
        let lines = Int(bounds.height)
        let densityMatrix = IBMatrix(columns: columns, lines: lines)
        
        var maxDensity: CGFloat = 0
        var firstMaxDensity: CGFloat = 0
        var secondMaxDensity: CGFloat = 0
        
        
        let sem = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .default)
        queue.async(execute: { () -> Void in
            for x in 0..<Int(floor(CGFloat(columns) / 2)) {
                for y in 0..<lines {
                    let point = CGPoint(x: x, y: y)
                    let density = self.density(for: point, bounds: bounds)
                    densityMatrix?.setObject(density, column: x, line: y)
                    if density > firstMaxDensity {
                        firstMaxDensity = density
                    }
                }
            }
            sem.signal()
        })
        
        queue.async(execute: { () -> Void in
            for x in Int(floor(CGFloat(columns) / 2))...columns {
                for y in 0..<lines {
                    let point = CGPoint(x: x, y: y)
                    let density = self.density(for: point, bounds: bounds)
                    densityMatrix?.setObject(density, column: x, line: y)
                    if density > secondMaxDensity {
                        secondMaxDensity = density
                    }
                }
            }
            sem.signal()
        })
        
        sem.wait()
        sem.wait()
        
        maxDensity = max(firstMaxDensity, secondMaxDensity)
        self.densityMatrix = densityMatrix
        return maxDensity
    }
    
    private func density(for point: CGPoint, bounds: CGRect) -> CGFloat {
        let density: CGFloat = 0
        for value in points {
            CGPoint userPoint = value.CGPointValue;
            CGPoint absoluteUserPoint = [self absolutePointForRelativePoint:userPoint bounds:bounds];
            CGFloat distanceBetweenPointAndCircle = fabsf(hypotf(point.x - absoluteUserPoint.x, point.y - absoluteUserPoint.y));
            if(distanceBetweenPointAndCircle <= self.pointRadius) {
                density+=(self.pointRadius - distanceBetweenPointAndCircle) / self.pointRadius;
            }
        }
        return density
    }
    
    private func color(for density: CGFloat, maxDensity: CGFloat) -> UIColor {
        if density < 1 {
            return
        }
    }
    {
    if(density < 1)
    return [self colorLerpFrom:[UIColor clearColor] to:self.colors[0] withDuration:density];
    
    CGFloat densityPercentage = density / maxDensity;
    CGFloat colorArrayPercentage = (self.colors.count - 1) * densityPercentage;
    
    NSInteger firstColorIndex = floor(colorArrayPercentage);
    NSInteger secondColorIndex = ceil(colorArrayPercentage);
    
    CGFloat colorRatio = colorArrayPercentage - firstColorIndex;
    
    return [self colorLerpFrom:self.colors[firstColorIndex] to:self.colors[secondColorIndex] withDuration:colorRatio];
    }
    
    private func colorLerpFrom(start: UIColor, end: UIColor, with duration: CGFloat) -> UIColor {
        let t = min(max(duration, 0), 1)
        
        let startComponent = start.cgColor.components?.first ?? 0
        let endComponent = end.cgColor.components?.first ?? 0
        
        const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
        const CGFloat *endComponent = CGColorGetComponents(end.CGColor);
        
        float startAlpha = CGColorGetAlpha(start.CGColor);
        float endAlpha = CGColorGetAlpha(end.CGColor);
        
        float r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
        float g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
        float b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
        float a = startAlpha + (endAlpha - startAlpha) * t;
        
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
}
