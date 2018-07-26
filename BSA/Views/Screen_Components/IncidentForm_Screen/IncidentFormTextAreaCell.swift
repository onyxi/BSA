//
//  IncidentFormTextAreaCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormTextAreaCell: UITableViewCell {

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
        
            // set cell's color, initial value text and add placeholder text
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellValueLabel.text = "Add Notes..."
        cellValueLabel.textColor = Constants.GRAY_LIGHT
    }
    
    // Sets the cell's value-label to reflect the 'notes' value of the incident
    func setValue(to value: String) {
        if value.count > 35 {
            cellValueLabel.numberOfLines = 0
        }
        cellValueLabel.text = value
        cellValueLabel.textColor = .black
    }
    


}
