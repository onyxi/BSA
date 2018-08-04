//
//  DateTimePickerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows a selected Date value to be sent to the delegate
protocol DateTimeSelectionDelegate {
    func setDateTime(to selection: Date)
}

class DateTimePickerVC: UIViewController {
    
    // UI handles:
    @IBOutlet weak var dateTimePicker: MaterialDatePicker!
    
    // Properties:
    var dateTimeSelectionDelegate: DateTimeSelectionDelegate?
    var selectedDateTime = Date()
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
    
            // set VC color, title and date/time picker initial position
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        dateTimePicker.maximumDate = Date()
    }
    
    // Sets parent VC's 'Date/Time' value to thic VC's selected value, before segueing back to parent VC
    @IBAction func okButtonPressed(_ sender: Any) {
        dateTimeSelectionDelegate?.setDateTime(to: selectedDateTime)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Updates selected date/time to picker's new value
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        selectedDateTime = sender.date
    }
    
    // Sets date/time picker's position to reflect the selected value (whch may have been passed through from delegate)
    override func viewWillAppear(_ animated: Bool) {
        dateTimePicker.setDate(selectedDateTime, animated: false)
    }
    
    
}
