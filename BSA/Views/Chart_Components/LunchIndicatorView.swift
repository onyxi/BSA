//
//  LunchIndicatorView.swift
//  BSA
//
//  Created by Pete Holdsworth on 19/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class LunchIndicatorView: UIView {

    // Properties:
    var gradient = CAGradientLayer()
    
    // Configure view appearance on load
    override func awakeFromNib() {
        self.backgroundColor = .clear
        
            // create color gradient
        let color1 = UIColor(red: 69/255, green: 165/255, blue: 207/255, alpha: 0.11).cgColor
        let color2 = UIColor(red: 123/255, green: 209/255, blue: 233/255, alpha: 0.0).cgColor
        gradient.colors = [color2, color1]
        
            // add grdient to view and round corners
        self.layer.addSublayer(gradient)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    // Updates the gradient-layer's frame size and position if the view's size/position changes
    override func layoutSubviews() {
        gradient.frame = self.bounds
    }

}
