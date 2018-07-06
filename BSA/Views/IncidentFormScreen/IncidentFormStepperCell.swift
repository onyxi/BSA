//
//  IncidentFormStepperCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol DurationSelectionDelegate {
    func setDuration(to duration: Int)
}

class IncidentFormStepperCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellValueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var durationSelectionDelegate: DurationSelectionDelegate!
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        cellValue = Int(sender.value)
        durationSelectionDelegate.setDuration(to: Int(sender.value))
    }
    
    var cellValue = 1 {
        didSet {
            updateCellValueLabel()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        updateCellValueLabel()
//        addSeparator()
    }

//    func addSeparator() {
//        
//    }
    
    func updateCellValueLabel() {
        if cellValue == 1 {
            cellValueLabel.text = "\(cellValue) minute"
        } else {
            cellValueLabel.text = "\(cellValue) minutes"
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
