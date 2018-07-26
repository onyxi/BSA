//
//  HorizontalBarChartLegend.swift
//  BSA
//
//  Created by Pete Holdsworth on 21/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class HorizontalBarChartLegend: UIView {

    // Configure view appearance on load
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // makes view circular and give black border line
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    

}
