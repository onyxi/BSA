//
//  NewIncidentButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class NewIncidentButton: ActionButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitle("New Incident", for: .normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 100, 5, 30)
    }
    
    override func draw(_ rect: CGRect) {
        
        let color = Constants.GRAY
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(6.0)
        context.setStrokeColor(color.cgColor)
        context.setLineCap(.round)
        context.beginPath()
        context.move(to: CGPoint(x: rect.maxX - 100, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.maxX - 70, y: rect.midY))
        context.move(to: CGPoint(x: rect.maxX - 85, y: rect.midY - 15))
        context.addLine(to: CGPoint(x: rect.maxX - 85, y: rect.midY + 15))
        context.strokePath()
        
    }
    
}
