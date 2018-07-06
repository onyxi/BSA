//
//  IncidentFormSegmentedCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol RestraintSelectionDelegate {
    func setRestraint(to restraint: Restraint)
}

class IncidentFormSegmentedCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var restraintSelectionDelegate: RestraintSelectionDelegate!
    
    var cellValue = 0
    
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        var restraint: Restraint!
        switch sender.selectedSegmentIndex {
        case 1:
            restraint = .nonRPI
        case 2:
            restraint = .unplannedRPI
        default:
            restraint = .RPI
        }
        restraintSelectionDelegate.setRestraint(to: restraint)
        cellValue = sender.selectedSegmentIndex
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentView.layer.backgroundColor = UIColor.white.cgColor
        segmentedControl.setTitle("Non RPI", forSegmentAt: 0)
        segmentedControl.setTitle("RPI", forSegmentAt: 1)
        segmentedControl.setTitle("Unplanned RPI", forSegmentAt: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
