//
//  DateTimePickerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

protocol DateTimeSelectionDelegate {
    func setDateTime(to selection: Date)
}

class DateTimePickerVC: UIViewController {
    
    @IBOutlet weak var dateTimePicker: MaterialDatePicker!
    var dateTimeSelectionDelegate: DateTimeSelectionDelegate?
    
    var selectedDateTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Please Select..."
        dateTimePicker.maximumDate = Date()
    }
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
        dateTimeSelectionDelegate?.setDateTime(to: selectedDateTime)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {
        selectedDateTime = sender.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateTimePicker.setDate(selectedDateTime, animated: false)
    }
    
    
}
