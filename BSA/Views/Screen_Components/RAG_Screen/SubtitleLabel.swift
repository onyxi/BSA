//
//  SubtitleLabel.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class SubtitleLabel: UILabel {

    // Sets the color of the arrow to blue - to represent the associated button as being enabled
    func enable() {
        self.textColor = Constants.BLUE
    }
    
    // Sets the color of the arrow to gray - to represent the associated button as being disabled
    func disable() {
        self.textColor = Constants.GRAY
    }
    
    // Removes the label from display
    func hide() {
        self.isHidden = true
    }
    
    // Displays the label if hidden 
    func show() {
        self.isHidden = false
    }
    
    // Makes the text color 'flash' briefly to white (to provide feedback when user presses an associated button) and animates to a given color (blue if the button is still active, gray if the button has become inactive)
    func flash(to color: UIColor) {
        self.textColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                self.textColor = color}, completion: nil)
        })
    }
    

}
