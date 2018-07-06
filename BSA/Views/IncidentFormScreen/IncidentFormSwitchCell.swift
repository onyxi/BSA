//
//  IncidentFormSwitchCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol AccidentFormCompletionDelegate {
    func setAccidentFormCompleted(to value: Bool)
}

protocol AlarmPressedDelegate {
    func setAlarmPressed(to value: Bool)
}

class IncidentFormSwitchCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    var accidentFormCompletionDelegate: AccidentFormCompletionDelegate?
    var alarmPressedDelegate: AlarmPressedDelegate?
    
    var cellValue = false {
        didSet {
            updateCellValueLabel()
        }
    }

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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        cellSwitch.isOn = false
        updateCellValueLabel()
    }
    
    func updateCellValueLabel() {
        if cellValue == true {
            cellValueLabel.text = "Yes"
        } else {
            cellValueLabel.text = "No"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
