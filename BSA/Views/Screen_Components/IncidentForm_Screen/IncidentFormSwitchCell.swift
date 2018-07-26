//
//  IncidentFormSwitchCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows an 'Accident-Form' cell's Boolean value to be sent to its delegate
protocol AccidentFormCompletionDelegate {
    func setAccidentFormCompleted(to value: Bool)
}

// Allows an 'Alarm-Pressed' cell's Boolean value to be sent to its parent VC
protocol AlarmPressedDelegate {
    func setAlarmPressed(to value: Bool)
}

class IncidentFormSwitchCell: UITableViewCell {
    
    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    // Properties:
    var accidentFormCompletionDelegate: AccidentFormCompletionDelegate?
    var alarmPressedDelegate: AlarmPressedDelegate?
    
        // cell's Boolean value - when changed the cell's value-label is also updated 
    var cellValue = false {
        didSet {
            updateCellValueLabel()
        }
    }
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellSwitch.isOn = false
        updateCellValueLabel()
    }

    
    // Sets the cell's value to true/false when the switch is pressed. Also updates the parent VC of the new value
    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn {
            cellValue = true
        } else {
            cellValue = false
        }
        if self.tag == 6 {
            accidentFormCompletionDelegate?.setAccidentFormCompleted(to: sender.isOn)
        } else if self.tag == 8 {
            alarmPressedDelegate?.setAlarmPressed(to: sender.isOn)
        }
        
    }
    
    // Updates the cell's value-label to reflect the cell's Booelan value
    func updateCellValueLabel() {
        if cellValue == true {
            cellValueLabel.text = "Yes"
        } else {
            cellValueLabel.text = "No"
        }
    }

}
