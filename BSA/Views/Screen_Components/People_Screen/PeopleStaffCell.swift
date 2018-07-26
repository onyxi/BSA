//
//  PeopleStaffCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 12/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class PeopleStaffCell: UITableViewCell {

    // UI handles:
    @IBOutlet weak var staffNameLabel: UILabel!
    
    // Properties:
    var entitySelectionDelegate: EntitySelectionDelegate!
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // Send's the cell's identity (row number) to the delegate when the user presses it
    @IBAction func cellButtonPressed(_ sender: Any) {
        entitySelectionDelegate.selectEntity(at: self.tag - 1)
    }
    
}
