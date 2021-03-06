//
//  UsernameButton.swift
//  BSA_v0.0
//
//  Created by Pete Holdsworth on 13/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class UsernameButton: MaterialButton {

    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set title text and position
        self.setTitle("Log In As...", for: .normal)
        self.setTitleColor(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0), for: .normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        self.titleEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 30)
    }
    
    // Perform custom drawing on loaded view
    override func draw(_ rect: CGRect) {
        
            // setup drawing context
        let color = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
            // draw 'arrow' symbol on the right side of the button
        context.setLineWidth(5.0)
        context.setStrokeColor(color.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: rect.maxX - 55, y: rect.midY - 15))
        context.addLine(to: CGPoint(x: rect.maxX - 40, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.maxX - 55, y: rect.midY + 15))
        context.setLineCap(.round)
        context.strokePath()
        
    }
    

}
