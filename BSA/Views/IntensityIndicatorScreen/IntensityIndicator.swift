//
//  IntensityIndicator.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IntensityIndicator: UIView {

    var gradient = CAGradientLayer()
    
    var indicator: IndicatorArrow!
    
    var intensity: Float = 0.5 {
        didSet {
            indicator.frame = CGRect(x: 0 - (self.frame.height * 0.5 / 2) + (self.frame.width * CGFloat(intensity)), y: 0 - self.frame.height * 0.5, width: self.frame.height * 0.5, height: self.frame.height * 1.5)
        }
    }
    
    func animateIntensity(to intensity: Float) {
        
        self.intensity = 0.0
        
        UIView.animate(withDuration: Constants.REPORT_ANIMATION_SPEED , delay: Constants.REPORT_ANIMATION_DELAY, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.indicator.frame = CGRect(x: 0 - (self.frame.height * 0.5 / 2) + (self.frame.width * CGFloat(intensity)), y: 0 - self.frame.height * 0.5, width: self.frame.height * 0.5, height: self.frame.height * 1.5)
        },completion: { _ in self.intensity = intensity })
    }
    
    override func awakeFromNib() {
        let color1 = UIColor(red: 111/255, green: 207/255, blue: 94/255, alpha: 1.0).cgColor
        let color2 = UIColor(red: 204/255, green: 215/255, blue: 76/255, alpha: 1.0).cgColor
        let color3 = UIColor(red: 209/255, green: 76/255, blue: 53/255, alpha: 1.0).cgColor
        gradient.colors = [color1, color2, color3]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.layer.addSublayer(gradient)
        
        indicator = IndicatorArrow(frame: CGRect(x: 0 - (self.frame.height * 0.5 / 2) + (self.frame.width * CGFloat(intensity)), y: 0 - self.frame.height * 0.5, width: self.frame.height * 0.5, height: self.frame.height * 1.5))
        self.addSubview(indicator)
    }
    
    override func layoutSubviews() {
        gradient.frame = self.bounds
    }

}
