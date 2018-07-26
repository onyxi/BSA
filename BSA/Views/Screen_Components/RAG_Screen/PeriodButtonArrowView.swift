//
//  PeriodButtonArrowView.swift
//  BSA
//
//  Created by Pete Holdsworth on 05/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeriodButtonArrowView: UIView {

    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
            // setup drawing context
        let color = Constants.GRAY_LIGHT
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(5.0)
        context.setStrokeColor(color.cgColor)
        
            // draw right-facing 'arrow' symbol to fill view
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX - 10, y: rect.midY - 15))
        context.addLine(to: CGPoint(x: rect.midX + 5, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.midX - 10, y: rect.midY + 15))
        context.setLineCap(.round)
        context.strokePath()
    }

}
