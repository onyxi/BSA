//
//  EntityDetailsSelectionCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows the cell to indicate to the delegate that the user has pressed on the Class cell and wishes to select a class for the entity
protocol ShowEntityClassSelectionDelegate {
    func showClassSelection()
}

class EntityDetailsSelectionCell: UITableViewCell {

    // UI handles:
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // Properties:
    var showEntityClassSelectionDelegate: ShowEntityClassSelectionDelegate!
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Indicates to the delegate that the user has pressed the Class cell
    @IBAction func classSelectionButtonPressed(_ sender: Any) {
        showEntityClassSelectionDelegate.showClassSelection()
    }
    
}
