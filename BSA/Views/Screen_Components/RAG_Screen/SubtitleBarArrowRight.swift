//
//  SubtitleBarArrowRight.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class SubtitleBarArrowRight: UIView {
    
    // Properties:
        // updates drawn arrow's color when this value is set
    var color = Constants.BLUE.cgColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set background color as transparent
        self.backgroundColor = UIColor.clear
    }
    
    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
            // setup drawing context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(4.0)
        context.setStrokeColor(color)
        
            // draw right-facing arrow to fill view
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + 10, y: rect.minY + 10))
        context.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.minX + 10, y: rect.maxY - 10))
        context.setLineCap(.round)
        context.strokePath()

    }
    
    // Removes the arrow from display
    func hide() {
        self.isHidden = true
    }
    
    // Displays the arrow if hidden
    func show() {
        self.isHidden = false
    }

    // Sets the color of the arrow to blue - to represent the associated button as being enabled
    func enable() {
        self.color = Constants.BLUE.cgColor
    }

    // Sets the color of the arrow to gray - to represent the associated button as being disabled
    func disable() {
        self.color = UIColor.clear.cgColor
    }
    
}
