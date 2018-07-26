//
//  ViewReportsButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 16/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class ViewReportsButton: ActionButton {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set and position title text
        self.setTitle("View Reports", for: .normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 35, 5, 30)
    }
    
    
    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
        // setup drawing context
        let color = Constants.GRAY_LIGHT
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(5.0)
        context.setStrokeColor(color.cgColor)
        
        // draw a right-facing arrow to the right of the view
        context.beginPath()
        context.move(to: CGPoint(x: rect.maxX - 50, y: rect.midY - 15))
        context.addLine(to: CGPoint(x: rect.maxX - 35, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.maxX - 50, y: rect.midY + 15))
        context.setLineCap(.round)
        context.strokePath()
        
    }

}
