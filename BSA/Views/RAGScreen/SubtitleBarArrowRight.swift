//
//  SubtitleBarArrowRight.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class SubtitleBarArrowRight: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    var color = UIColor.clear.cgColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(4.0)
        context.setStrokeColor(color)
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX + 10, y: rect.minY + 10))
        context.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.minX + 10, y: rect.maxY - 10))
        context.setLineCap(.round)
        context.strokePath()

    }

    func enable() {
        self.color = Constants.SUBTITLE_BAR_BLUE.cgColor
    }

    func disable() {
        self.color = UIColor.clear.cgColor
    }
    
}
