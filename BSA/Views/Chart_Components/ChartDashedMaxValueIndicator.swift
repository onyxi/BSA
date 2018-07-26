//
//  ChartDashedMaxValueIndicator.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ChartDashedMaxValueIndicator: UIView {

    // Configure view appearance on load
    override func awakeFromNib() {
        self.backgroundColor = .clear
    }
    
    
    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
            // setup drawing context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineDash(phase: 7, lengths: [3])
        
            // draw a dashed line to fill the view
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        context.strokePath()
        
    }

}
