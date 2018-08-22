//
//  PeopleClassCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 12/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows the cell to pass it's row number to the delegate - to identify the cell that the user has pressed
protocol EntitySelectionDelegate {
    func selectEntity(at index: Int)
}

class PeopleClassCell: UITableViewCell {

    // UI handles:
    @IBOutlet weak var classNameLabel: UILabel!
    
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
