//
//  SubtitleLabel.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class SubtitleLabel: UILabel {

    func enable() {
        self.textColor = Constants.SUBTITLE_BAR_BLUE
    }
    
    func disable() {
        self.textColor = Constants.SUBTITLE_BAR_GRAY
    }
    
    func flash(to color: UIColor) {
        self.textColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve, animations: {
                self.textColor = color}, completion: nil)
        })
    }
    

}
