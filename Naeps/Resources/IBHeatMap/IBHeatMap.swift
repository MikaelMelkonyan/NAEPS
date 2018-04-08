//
//  IBHeatMap.swift
//  Naeps
//
//  Created by Mikael on 4/8/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

class IBHeatMap: UIView {
    
    private let colors: [UIColor]
    private let pointRadius: CGFloat
    
    private var points = [CGPoint]()
    private var delegate: IBHeatMapDelegate?
    
    init(frame: CGRect, 
         colors: [UIColor] = [UIColor.green, UIColor.yellow, UIColor.red],
         pointRadius: CGFloat = 20) {
        self.colors = colors
        self.pointRadius = pointRadius
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
