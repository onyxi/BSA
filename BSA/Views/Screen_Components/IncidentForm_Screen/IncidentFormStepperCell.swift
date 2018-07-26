//
//  IncidentFormStepperCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows the cell's numeric value to be sent to its delegate
protocol DurationSelectionDelegate {
    func setDuration(to duration: Int)
}

class IncidentFormStepperCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    // Properties:
    var durationSelectionDelegate: DurationSelectionDelegate!
    
        // cell's numeric value - when changed the cell's value-label is also updated
    var cellValue = 1 {
        didSet {
            updateCellValueLabel()
        }
    }
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
            // set cell's color and update value-label's initial value
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        updateCellValueLabel()
    }
    
    // Increase or decrease the cell's value when the stepper is pressed. Also updates the parent VC of the new value
    @IBAction func stepperPressed(_ sender: UIStepper) {
        cellValue = Int(sender.value)
        durationSelectionDelegate.setDuration(to: Int(sender.value))
    }

    // Updates the cell's value-label to reflect the cell's numeric value
    func updateCellValueLabel() {
        if cellValue == 1 {
            cellValueLabel.text = "\(cellValue) minute"
        } else {
            cellValueLabel.text = "\(cellValue) minutes"
        }
    }
    
}
