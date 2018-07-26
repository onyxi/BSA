//
//  IncidentFormSegmentedCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows the cell's 'Restraint' value to be sent to its delegate
protocol RestraintSelectionDelegate {
    func setRestraint(to restraint: String)
}

class IncidentFormSegmentedCell: UITableViewCell {

    // UI handles:
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Properties:
    var restraintSelectionDelegate: RestraintSelectionDelegate!
    var cellValue = 0
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()

            // set cell's color and segmented control's element labels
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        segmentedControl.setTitle("Non RPI", forSegmentAt: 0)
        segmentedControl.setTitle("RPI", forSegmentAt: 1)
        segmentedControl.setTitle("Unplanned RPI", forSegmentAt: 2)
    }
    
    // Sets the cell's 'Restraint' when the segmented control is pressed. Also updates the parent VC of the new value
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        var restraint: String!
        switch sender.selectedSegmentIndex {
        case 1:
            restraint = Constants.RESTRAINT[0]
        case 2:
            restraint = Constants.RESTRAINT[1]
        default:
            restraint = Constants.RESTRAINT[2]
        }
        restraintSelectionDelegate.setRestraint(to: restraint)
        cellValue = sender.selectedSegmentIndex
    }
    


}
