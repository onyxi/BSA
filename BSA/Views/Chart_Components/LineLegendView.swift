//
//  LineLegendView.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class LineLegendView: UIView {
    
    // Configure view appearance on load
    override func awakeFromNib() {
        self.backgroundColor = .clear
    }

    // Custom initialiser
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // Required initialiser
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
            // setup context
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(4.0)
        context.setStrokeColor(Constants.PURPLE.cgColor)

            // draw line
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        context.strokePath()
        
    }

}
