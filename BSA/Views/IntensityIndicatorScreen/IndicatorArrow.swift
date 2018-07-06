//
//  IndicatorArrow.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IndicatorArrow: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var color = UIColor(red: 72/255, green: 139/255, blue: 205/255, alpha: 1.0)
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.black.cgColor)
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: (rect.maxY / 3.0) - (self.frame.height * 0.02)))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        context.closePath()
        color.setFill()
        context.fillPath()
        context.move(to: CGPoint(x: (rect.maxX / 2.0), y: (rect.maxY / 3.0)))
        context.addLine(to: CGPoint(x: rect.maxX / 2.0, y: rect.maxY))
        context.strokePath()
        
    }
    
}
