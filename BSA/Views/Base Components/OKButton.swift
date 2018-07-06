//
//  OKButton.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class OKButton: ActionButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitle("OK", for: .normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 55, 5, 30)
    }
    
    override func draw(_ rect: CGRect) {
        
        let color = UIColor(red: 124/255, green: 227/255, blue: 128/255, alpha: 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(6.0)
        context.setStrokeColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.maxX - 70, y: rect.midY - 5))
        context.addLine(to: CGPoint(x: rect.maxX - 55, y: rect.midY + 10))
        context.addLine(to: CGPoint(x: rect.maxX - 30, y: rect.midY - 20))
        context.strokePath()
        
    }

}
