//
//  IncidentFormSelectionCellTableViewCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormSelectionCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    var cellPlaceholderLabel: UILabel!
    var arrowView: CellArrowView!

    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set color and initial value text
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellValueLabel.text = "Please Select"
        cellValueLabel.textColor = Constants.GRAY_LIGHT
    }
    
    // Updates cell's value and text representation
    func setValue(to value: String) {
        cellValueLabel.text = value
        cellValueLabel.textColor = .black
    }
    
    // Sets the cell's value label to allow for multiple-line values
    func setMultiLine() {
        cellValueLabel.numberOfLines = 0
    }

}
