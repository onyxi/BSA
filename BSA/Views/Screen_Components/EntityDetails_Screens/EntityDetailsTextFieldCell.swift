//
//  EntityDetailsTextFieldCell.swift
//  BSA
//
//  Created by Pete Holdsworth on 13/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows the cell's textField value to be passed to the delegate when the user edits it
protocol EntityDetailsTextFieldDelegate {
    func textFieldChanged(to value: String, for cellTag: Int)
}

class EntityDetailsTextFieldCell: UITableViewCell, UITextFieldDelegate {

    // UI handles:
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    // Properties:
    var entityDetailsTextFieldDelegate: EntityDetailsTextFieldDelegate!
    
    // Configure view appearance when loaded
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(EntityDetailsTextFieldCell.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    // Send's the cell's textField value to the delegate when the user edits it
    @objc func textFieldDidChange(_ textField: UITextField) {
        entityDetailsTextFieldDelegate.textFieldChanged(to: textField.text!, for: self.tag)
    }

}
