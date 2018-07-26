//
//  IntensityIndicator.swift
//  BSA
//
//  Created by Pete Holdsworth on 28/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IntensityIndicator: UIView {

    // Properties:
    var indicator: IndicatorArrow!
    var gradient = CAGradientLayer()
    
        // value of the indicator (chart) - updates position of the Indicator Arrow when this value is set
    var intensity: Float = 0.0 {
        didSet {
            indicator.frame = CGRect(x: 0 - (self.frame.height * 0.5 / 2) + (self.frame.width * CGFloat(intensity)), y: 0 - self.frame.height * 0.5, width: self.frame.height * 0.5, height: self.frame.height * 1.5)
        }
    }
    
    // Animates the position of the Indicator Arrow from a value of zero to the given value - updating the chart's intensity value to the given value when the animation is complete
    func animateIntensity(to intensity: Float) {
        self.intensity = 0.0
        UIView.animate(withDuration: Constants.REPORT_ANIMATION_SPEED , delay: Constants.REPORT_ANIMATION_DELAY, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.indicator.frame = CGRect(x: 0 - (self.frame.height * 0.5 / 2) + (self.frame.width * CGFloat(intensity)), y: 0 - self.frame.height * 0.5, width: self.frame.height * 0.5, height: self.frame.height * 1.5)
        },completion: { _ in self.intensity = intensity })
    }
    
    // Configure view appearance on load
    override func awakeFromNib() {
        
            // add color gradient to the chart
        let color1 = UIColor(red: 111/255, green: 207/255, blue: 94/255, alpha: 1.0).cgColor
        let color2 = UIColor(red: 204/255, green: 215/255, blue: 76/255, alpha: 1.0).cgColor
        let color3 = UIColor(red: 209/255, green: 76/255, blue: 53/255, alpha: 1.0).cgColor
        gradient.colors = [color1, color2, color3]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.addSublayer(gradient)
        
            // create and add an Indicator Arrow view above the chart as a visual representation of the its 'intensity' value
        indicator = IndicatorArrow(frame: CGRect(x: 0 - (self.frame.height * 0.5 / 2) + (self.frame.width * CGFloat(intensity)), y: 0 - self.frame.height * 0.5, width: self.frame.height * 0.5, height: self.frame.height * 1.5))
        self.addSubview(indicator)
    }
    
    // Updates the bounds of the chart's gradient (eg. when screen is rotated)
    override func layoutSubviews() {
        gradient.frame = self.bounds
    }

}
