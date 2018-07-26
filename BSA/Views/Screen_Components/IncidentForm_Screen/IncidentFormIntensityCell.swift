//
//  IncidentFormIntensityCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 30/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormIntensityCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellIntensityIndicator: IntensityIndicator!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellPlaceholderLabel: UILabel!
    var arrowView: CellArrowView!
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
           // set cell color, add initial placeholder and hide Intensity Indicator view for initial nil value
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellPlaceholderLabel.text = "Please Indicate..."
        cellPlaceholderLabel.textColor = Constants.GRAY_LIGHT
        cellIntensityIndicator.isHidden = true
    }
    
    // Displays a small Intensity Indicator view on the cell - set to the given value
    func setIntensityIndicatorValue(to value: Float) {
        guard value >= 0.0 && value <= 1.0 else { return }
        cellPlaceholderLabel.text = ""
        cellIntensityIndicator.intensity = value
        cellIntensityIndicator.isHidden = false
    }
    
}
