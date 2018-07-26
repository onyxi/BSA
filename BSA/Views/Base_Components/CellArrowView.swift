//
//  CellArrowView.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class CellArrowView: UIView {
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        self.backgroundColor = .clear
    }

    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
            // setup drawing context
        let color = Constants.GRAY_LIGHT
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(5.0)
        context.setStrokeColor(color.cgColor)
        
            // draw a right-facing arrow to fill the view
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX - 10, y: rect.midY - 15))
        context.addLine(to: CGPoint(x: rect.midX + 5, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.midX - 10, y: rect.midY + 15))
        context.setLineCap(.round)
        context.strokePath()
    }

}
