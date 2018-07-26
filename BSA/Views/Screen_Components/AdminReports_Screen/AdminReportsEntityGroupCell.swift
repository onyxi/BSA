//
//  AdminReportsEntityGroupCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 16/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol EntityGroupSwitchDelegate {
    func selectionSwitchChangedValueFor(cellWithTag tag: Int, to value: Bool)
}

class AdminReportsEntityGroupCell: UITableViewCell {

    // UI handles:
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionSwitch: UISwitch!
    
    var entityGroupSwitchDelegate: EntityGroupSwitchDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = Constants.GRAY_VERY_LIGHT
        selectionSwitch.isOn = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Notifies the delegate that the cell's UIswitch value has been changed
    @IBAction func selectionSwitchValueChanged(_ sender: UISwitch) {
        entityGroupSwitchDelegate.selectionSwitchChangedValueFor(cellWithTag: self.tag, to: sender.isOn)
    }
    

}
