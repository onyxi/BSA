//
//  IncidentFormVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DateTimeSelectionDelegate, DurationSelectionDelegate, StudentSelectionDelegate, BehaviourSelectionDelegate, IntensitySelectionDelegate, StaffSelectionDelegate, AccidentFormCompletionDelegate, RestraintSelectionDelegate, AlarmPressedDelegate, PurposeSelectionDelegate, NotesAdditionDelegate {
    
    
    
    // UI handles:
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    /// Properties:
    var incidentDateTime: Date?
    var incidentDuration = 1
    var incidentStudent: Int?
    var incidentBehaviours: [String]?
    var incidentIntensity: Float?
    var incidentStaff: [Int]?
    var incidentAccidentFormCompleted = false
    var incidentRestraint = Constants.RESTRAINT[0]
    var incidentAlarmPressed = false
    var incidentPurposes: [String]?
    var incidentNotes = ""

    // Configures view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "New Incident"
        
            // set up table of incident aspects
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    // Submits a completed Incident Form to be saved to storage. If not all fields have been completed, an alert is shown to the user to inform them they must do so before submitting. Animates back to parent VC when submission is successful.
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        
            // check if all fields have been provided
        guard incidentDateTime != nil && incidentStudent != nil && incidentBehaviours != nil && incidentIntensity != nil && incidentStaff != nil && incidentPurposes != nil else {
            
                // if not, show alert to inform all fields are required
            let alert = UIAlertController(title: "Incident Form Incomplete", message: "Please complete all sections of the form before saving changes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
            // create Incident object from field data
        let incident = Incident(id: NSUUID().uuidString, dateTime: incidentDateTime!, duration: incidentDuration, student: incidentStudent!, behaviours: incidentBehaviours!, intensity: incidentIntensity!, staff: incidentStaff!, accidentFormCompleted: incidentAccidentFormCompleted, restraint: incidentRestraint, alarmPressed: incidentAlarmPressed, purposes: incidentPurposes!, notes: incidentNotes)
//            Incident(id: "I1", incidentNumber: 1, dateTime: incidentDateTime!, duration: incidentDuration, student: incidentStudent!, behaviours: incidentBehaviours!, intensity: incidentIntensity!, staff: incidentStaff!, accidentFormCompleted: incidentAccidentFormCompleted, restraint: incidentRestraint, alarmPressed: incidentAlarmPressed, purposes: incidentPurposes!, notes: incidentNotes)
        
            // commit Incident object to storage
        print(incident)
        
            // show alert to inform user that submission was successful
        let alert = UIAlertController(title: "Incident Saved", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
            // animate back to parent VC
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Sets the new Incident Form's 'Date/Time' property to the value selected in delegated VC - and updates the 'Date/Time' cell's value label
    func setDateTime(to selection: Date) {
        if let dateTimeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? IncidentFormSelectionCell {
            dateTimeCell.setValue(to: "\(DataService.getShortDateString(for: selection))        \(DataService.getTimeString(for: selection))")
            self.incidentDateTime = selection
        }
    }
    
    // Sets the new Incident Form's 'Duration' property to the value selected in delegated VC - and updates the 'Duration' cell's value label
    func setDuration(to duration: Int) {
        self.incidentDuration = duration
    }
    
    // Sets the new Incident Form's 'Student' property to the value selected in delegated VC - and updates the 'Student' cell's value label
    func setStudent(to selection: Student) {
        if let studentCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? IncidentFormSelectionCell {
            studentCell.setValue(to: "\(selection.firstName!) \(selection.lastName!)")
            self.incidentStudent = selection.studentNumber
        }
    }
    
    // Sets the new Incident Form's 'Behaviours' property to the value selected in delegated VC - and updates the 'Behaviours' cell's value label
    func setBehaviours(to selection: [String]) {
        self.incidentBehaviours = selection
        var behavioursString = ""
        for i in 1...selection.count {
            if i < selection.count {
                behavioursString.append("\(selection[i-1])\n")
            } else {
                behavioursString.append("\(selection[i-1])")
            }
        }
        if let behavioursCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? IncidentFormSelectionCell {
            behavioursCell.setValue(to: behavioursString)
            if selection.count > 1 {
                behavioursCell.setMultiLine()
            }
            self.incidentBehaviours = selection
        }
        tableView.reloadData()
    }
    
    // Sets the new Incident Form's 'Intensity' property to the value selected in delegated VC - and updates the 'Intensity' cell's value label
    func setIntensity(to selection: Float) {
        if let intensityCell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? IncidentFormIntensityCell {
            intensityCell.setIntensityIndicatorValue(to: selection)
            self.incidentIntensity = selection
        }
    }
    
    // Sets the new Incident Form's 'Staff' property to the value selected in delegated VC - and updates the 'Staff' cell's value label
    func setStaff(to selection: [Staff]) {
//        self.incidentStaff = selection
        var incidentStaff = [Int]()
        var staffString = ""
        for i in 1...selection.count {
            incidentStaff.append(selection[i-1].staffNumber)
            if i < selection.count {
                staffString.append("\(selection[i-1].firstName!) \(selection[i-1].lastName!)\n")
            } else {
                staffString.append("\(selection[i-1].firstName!) \(selection[i-1].lastName!)")
            }
            
        }
        if let staffCell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? IncidentFormSelectionCell {
            staffCell.setValue(to: staffString)
            if selection.count > 1 {
                staffCell.setMultiLine()
            }
            self.incidentStaff = incidentStaff
//            self.incidentStaff = selection
        }
        tableView.reloadData()
    }

    // Sets the new Incident Form's 'Form Completed' property to the value selected in delegated VC - and updates the 'Form Completed' cell's value label
    func setAccidentFormCompleted(to value: Bool) {
        self.incidentAccidentFormCompleted = value
    }

    // Sets the new Incident Form's 'Restraint' property to the value selected in delegated VC - and updates the 'Restraint' cell's value label
    func setRestraint(to restraintType: String) {
        self.incidentRestraint = restraintType
    }

    // Sets the new Incident Form's 'Alarm Pressed' property to the value selected in delegated VC - and updates the 'Alarm Pressed' cell's value label
    func setAlarmPressed(to value: Bool) {
        self.incidentAlarmPressed = value
    }

    // Sets the new Incident Form's 'Purpose' property to the value selected in delegated VC - and updates the 'Purpose' cell's value label
    func setPurpose(to selection: [String]) {
        self.incidentPurposes = selection
        var purposesString = ""
        for i in 1...selection.count {
            if i < selection.count {
                purposesString.append("\(selection[i-1])\n")
            } else {
                purposesString.append("\(selection[i-1])")
            }
        }
        if let purposesCell = tableView.cellForRow(at: IndexPath(row: 10, section: 0)) as? IncidentFormSelectionCell {
            purposesCell.setValue(to: purposesString)
            if selection.count > 1 {
                purposesCell.setMultiLine()
            }
            self.incidentPurposes = selection
        }
        tableView.reloadData()
    }

    // Sets the new Incident Form's 'Notes' property to the value selected in delegated VC - and updates the 'Notes' cell's value label
    func setNotes(to note: String) {
        if let notesCell = tableView.cellForRow(at: IndexPath(row: 11, section: 0)) as? IncidentFormTextAreaCell {
            self.incidentNotes = note
            notesCell.setValue(to: note)
            self.incidentNotes = note
        }
        tableView.reloadData()
    }
    
    
    // Triggers segue to appropriate child VC when a Selection Cell is pressed
    @objc fileprivate func selectionCellPressed(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch sender.tag {
            
            // segue to Date/Time Picker VC
        case 1:
            let dateTimePickerVC = storyboard.instantiateViewController(withIdentifier: "DateTimePickerVC") as! DateTimePickerVC
            dateTimePickerVC.dateTimeSelectionDelegate = self
            dateTimePickerVC.hidesBottomBarWhenPushed = true
            if incidentDateTime != nil {
                dateTimePickerVC.selectedDateTime = incidentDateTime!
            }
            self.navigationController?.pushViewController(dateTimePickerVC, animated: true)
            
            // segue to Student Selection VC
        case 3:
            let studentSelectionVC = storyboard.instantiateViewController(withIdentifier: "StudentSelectionVC") as! StudentSelectionVC
            if incidentStudent != nil {
                studentSelectionVC.selectedStudentNumber = incidentStudent
            }
            studentSelectionVC.studentSelectionDelegate = self
            studentSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(studentSelectionVC, animated: true)
            
            // segue to Student Selection VC
        case 4:
            let behaviourSelectionVC = storyboard.instantiateViewController(withIdentifier: "BehaviourSelectionVC") as! BehaviourSelectionVC
            if incidentBehaviours != nil {
                behaviourSelectionVC.selectedBehaviours = incidentBehaviours!
            }
            behaviourSelectionVC.behaviourSelectionDelegate = self
            behaviourSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(behaviourSelectionVC, animated: true)
            
            // segue to Intensity Selection VC
        case 5:
            let intensityIndicatorVC = storyboard.instantiateViewController(withIdentifier: "IntensityIndicatorVC") as! IntensityIndicatorVC
            intensityIndicatorVC.intensityIndicationDelegate = self
            intensityIndicatorVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(intensityIndicatorVC, animated: true)
            
            // segue to Staff Selection VC
        case 6:
            let staffSelectionVC = storyboard.instantiateViewController(withIdentifier: "StaffSelectionVC") as! StaffSelectionVC
            if incidentStaff != nil {
                staffSelectionVC.selectedStaffNumbers = incidentStaff!
            }
            staffSelectionVC.staffSelectionDelegate = self
            staffSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(staffSelectionVC, animated: true)
            
            // segue to Purposes Selection VC
        case 10:
            let purposeSelectionVC = storyboard.instantiateViewController(withIdentifier: "PurposeSelectionVC") as! PurposeSelectionVC
            if incidentPurposes != nil {
                purposeSelectionVC.selectedPurposes = incidentPurposes!
            }
            purposeSelectionVC.purposeSelectionDelegate = self
            purposeSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(purposeSelectionVC, animated: true)
            
            // segue to Notes Addition VC
        case 11:
            let notesVC = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
            notesVC.notesAdditionDelegate = self
            notesVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notesVC, animated: true)
        default:
            break
        }
    }
    
    // Sets number of rows in the table of Incident Form cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }

    
    // Configures cells in the Incident Form table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {

            // configure 'Date/Time' picker cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Date & Start Time"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure 'Duration' stepper cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormStepperCell", for: indexPath) as! IncidentFormStepperCell
            cell.cellTitleLabel.text = "Duration"
            cell.durationSelectionDelegate = self
            return cell
            
            // configure 'Student' selection cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Student"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure 'Behaviours' selection cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Type of Behaviour"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure 'Intensity' selection cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormIntensityCell", for: indexPath) as! IncidentFormIntensityCell
            cell.cellTitleLabel.text = "Intensity"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure 'Staff' selection cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Staff Members"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure 'Accident Form Completed' switch cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSwitchCell", for: indexPath) as! IncidentFormSwitchCell
            cell.cellTitleLabel.text = "Accident Form Completed"
            cell.accidentFormCompletionDelegate = self
            return cell
            
            // configure 'Restraint' selection cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSegmentedCell", for: indexPath) as! IncidentFormSegmentedCell
            cell.cellTitleLabel.text = "Restraint"
            cell.restraintSelectionDelegate = self
            return cell
            
            // configure 'Alarm Pressed' switch cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSwitchCell", for: indexPath) as! IncidentFormSwitchCell
            cell.cellTitleLabel.text = "Alarm Pressed"
            cell.alarmPressedDelegate = self
            return cell
            
            // configure 'Purposes' selection cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Purpose"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure 'Notes' text area cell
        case 11:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormTextAreaCell", for: indexPath) as! IncidentFormTextAreaCell
            cell.cellTitleLabel.text = "Notes"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
            
            // configure top and lst cells as transparent, padding cells
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        }
    }
    
    // Sets the height for cells in table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            // transparent top padding cell
        if indexPath.row == 0 {
            return 20
            
            // calculate Behaviours cell height to accommoate multiple behaviours
        } else if indexPath.row == 4 {
            guard incidentBehaviours != nil else { return 70 }
            if incidentBehaviours!.count > 1 {
                return CGFloat(50 + (incidentBehaviours!.count * 20))
            }
            
            // calculate Staff cell height to accommoate multiple staff members
        } else if indexPath.row == 6 {
            guard incidentStaff != nil else { return 70 }
            if incidentStaff!.count > 1 {
                return CGFloat(50 + (incidentStaff!.count * 20))
            }
            
            // calculate Purposes cell height to accommoate multiple purposes
        } else if indexPath.row == 10 {
            guard incidentPurposes != nil else { return 70 }
            if incidentPurposes!.count > 1 {
                return CGFloat(50 + (incidentPurposes!.count * 20))
            }
            
            // calculate Notes cell height to accommoate multiple lines of notes
        } else if indexPath.row == 11 {
            if incidentNotes.count > 35 {
                let numberExtraLinesNeeded = Int(incidentNotes.count / 35)
                return CGFloat(50 + (numberExtraLinesNeeded * 20))
            }
            
            // transparent bottom cell - containing 'Save Changes' button
        } else if indexPath.row == 12 {
            return 125
        }
        
            // default height for single-line cells
        return 70
    }
    

}
