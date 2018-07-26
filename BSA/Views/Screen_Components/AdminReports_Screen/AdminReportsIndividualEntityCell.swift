//
//  AdminReportsIndividualEntityCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 16/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol IndividualEntitySwitchDelegate {
    func selectionSwitchChangedValueFor(cellWithTag tag: Int, to value: Bool)
}

class AdminReportsIndividualEntityCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    var individualEntitySwitchDelegate: IndividualEntitySwitchDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white
        selectionSwitch.isOn = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    // Notifies the delegate that the cell's UIswitch value has been changed
    @IBAction func selectionSwitchValueChanged(_ sender: UISwitch) {
        individualEntitySwitchDelegate.selectionSwitchChangedValueFor(cellWithTag: self.tag, to: sender.isOn)
    }
}
