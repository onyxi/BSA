//
//  IncidentFormVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 20/06/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class IncidentFormVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DateTimeSelectionDelegate, DurationSelectionDelegate, StudentSelectionDelegate, BehaviourSelectionDelegate, IntensitySelectionDelegate, StaffSelectionDelegate, AccidentFormCompletionDelegate, RestraintSelectionDelegate, AlarmPressedDelegate, PurposeSelectionDelegate, NotesAdditionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var incidentDateTime: Date?
    var incidentDuration = 1
    var incidentStudent: Student?
    var incidentBehaviours: [Behaviour]?
    var incidentIntensity: Float?
    var incidentStaff: [Staff]?
    var incidentAccidentFormCompleted = false
    var incidentRestraint: Restraint = .nonRPI
    var incidentAlarmPressed = false
    var incidentPurposes: [Purpose]?
    var incidentNotes = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.layer.backgroundColor = Constants.INCIDENTS_SCREEN_COLOR.cgColor
        self.navigationItem.title = "New Incident"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        if incidentDateTime != nil && incidentDuration != nil && incidentStudent != nil && incidentBehaviours != nil && incidentIntensity != nil && incidentStaff != nil && incidentPurposes != nil {
            
            let incident = Incident(id: "I1", dateTime: incidentDateTime!, duration: incidentDuration, student: incidentStudent!, behaviours: incidentBehaviours!, intensity: incidentIntensity!, staff: incidentStaff!, accidentFormCompleted: incidentAccidentFormCompleted, restraint: incidentRestraint, alarmPressed: incidentAlarmPressed, purposes: incidentPurposes!, notes: incidentNotes)
            
            print(incident)
            
            let alert = UIAlertController(title: "Incident Saved", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Incident Form Incomplete", message: "Please complete all sections of the form before saving changes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setDateTime(to selection: Date) {
        if let dateTimeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? IncidentFormSelectionCell {
            dateTimeCell.setValue(to: "\(Data.getShortDateString(for: selection))        \(Data.getTimeString(for: selection))")
            self.incidentDateTime = selection
        }
    }
    
    func setDuration(to duration: Int) {
        if let durationStepperCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? IncidentFormStepperCell {
            self.incidentDuration = duration
        }
    }
    
    func setStudent(to selection: Student) {
        if let studentCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? IncidentFormSelectionCell {
            studentCell.setValue(to: "\(selection.firstName!) \(selection.lastName!)")
            self.incidentStudent = selection
        }
    }
    
    func setBehaviours(to selection: [Behaviour]) {
        self.incidentBehaviours = selection
        var behavioursString = ""
        for i in 1...selection.count {
            if i < selection.count {
                behavioursString.append("\(selection[i-1].type!)\n")
            } else {
                behavioursString.append("\(selection[i-1].type!)")
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
    
    func setIntensity(to selection: Float) {
        if let intensityCell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? IncidentFormIntensityCell {
            intensityCell.setIntensityIndicatorValue(to: selection)
            self.incidentIntensity = selection
        }
    }
    
    func setStaff(to selection: [Staff]) {
        self.incidentStaff = selection
        var staffString = ""
        for i in 1...selection.count {
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
            self.incidentStaff = selection
        }
        tableView.reloadData()
    }

    func setAccidentFormCompleted(to value: Bool) {
        if let accidentFormCompletionCell = tableView.cellForRow(at: IndexPath(row: 7, section: 0)) as? IncidentFormSwitchCell {
            self.incidentAccidentFormCompleted = value
        }
    }

    func setRestraint(to restraintType: Restraint) {
        if let restraintCell = tableView.cellForRow(at: IndexPath(row: 8, section: 0)) as? IncidentFormSegmentedCell {
            self.incidentRestraint = restraintType
        }
    }

    func setAlarmPressed(to value: Bool) {
        if let alarmPressedCell = tableView.cellForRow(at: IndexPath(row: 9, section: 0)) as? IncidentFormSwitchCell {
            self.incidentAlarmPressed = value
        }
    }

    func setPurpose(to selection: [Purpose]) {
        self.incidentPurposes = selection
        var purposesString = ""
        for i in 1...selection.count {
            if i < selection.count {
                purposesString.append("\(selection[i-1].type!)\n")
            } else {
                purposesString.append("\(selection[i-1].type!)")
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

    func setNotes(to note: String) {
        if let notesCell = tableView.cellForRow(at: IndexPath(row: 11, section: 0)) as? IncidentFormTextAreaCell {
            self.incidentNotes = note
            notesCell.setValue(to: note)
            self.incidentNotes = note
        }
        tableView.reloadData()
    }
    
    @objc fileprivate func selectionCellPressed(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch sender.tag {
        case 1:
            let dateTimePickerVC = storyboard.instantiateViewController(withIdentifier: "DateTimePickerVC") as! DateTimePickerVC
            dateTimePickerVC.dateTimeSelectionDelegate = self
            dateTimePickerVC.hidesBottomBarWhenPushed = true
            if incidentDateTime != nil {
                dateTimePickerVC.selectedDateTime = incidentDateTime!
            }
            self.navigationController?.pushViewController(dateTimePickerVC, animated: true)
        case 3:
            let studentSelectionVC = storyboard.instantiateViewController(withIdentifier: "StudentSelectionVC") as! StudentSelectionVC
            if incidentStudent != nil {
                studentSelectionVC.selectedStudent = incidentStudent
            }
            studentSelectionVC.studentSelectionDelegate = self
            studentSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(studentSelectionVC, animated: true)
        case 4:
            let behaviourSelectionVC = storyboard.instantiateViewController(withIdentifier: "BehaviourSelectionVC") as! BehaviourSelectionVC
            if incidentBehaviours != nil {
                behaviourSelectionVC.selectedBehaviours = incidentBehaviours!
            }
            behaviourSelectionVC.behaviourSelectionDelegate = self
            behaviourSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(behaviourSelectionVC, animated: true)
        case 5:
            let intensityIndicatorVC = storyboard.instantiateViewController(withIdentifier: "IntensityIndicatorVC") as! IntensityIndicatorVC
            intensityIndicatorVC.intensityIndicationDelegate = self
            intensityIndicatorVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(intensityIndicatorVC, animated: true)
        case 6:
            let staffSelectionVC = storyboard.instantiateViewController(withIdentifier: "StaffSelectionVC") as! StaffSelectionVC
            if incidentStaff != nil {
                staffSelectionVC.selectedStaff = incidentStaff!
            }
            staffSelectionVC.staffSelectionDelegate = self
            staffSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(staffSelectionVC, animated: true)
        case 10:
            let purposeSelectionVC = storyboard.instantiateViewController(withIdentifier: "PurposeSelectionVC") as! PurposeSelectionVC
            if incidentPurposes != nil {
                purposeSelectionVC.selectedPurposes = incidentPurposes!
            }
            purposeSelectionVC.purposeSelectionDelegate = self
            purposeSelectionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(purposeSelectionVC, animated: true)
        case 11:
            let notesVC = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
            notesVC.notesAdditionDelegate = self
            notesVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notesVC, animated: true)
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormTopPaddingCell", for: indexPath) as! TransparentCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Date & Start Time"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormStepperCell", for: indexPath) as! IncidentFormStepperCell
            cell.cellTitleLabel.text = "Duration"
            cell.durationSelectionDelegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Student"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Type of Behaviour"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormIntensityCell", for: indexPath) as! IncidentFormIntensityCell
            cell.cellTitleLabel.text = "Intensity"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Staff Members"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSwitchCell", for: indexPath) as! IncidentFormSwitchCell
            cell.cellTitleLabel.text = "Accident Form Completed"
            cell.accidentFormCompletionDelegate = self
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSegmentedCell", for: indexPath) as! IncidentFormSegmentedCell
            cell.cellTitleLabel.text = "Restraint"
            cell.restraintSelectionDelegate = self
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSwitchCell", for: indexPath) as! IncidentFormSwitchCell
            cell.cellTitleLabel.text = "Alarm Pressed"
            cell.alarmPressedDelegate = self
            return cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
            cell.cellTitleLabel.text = "Purpose"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
        case 11:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormTextAreaCell", for: indexPath) as! IncidentFormTextAreaCell
            cell.cellTitleLabel.text = "Notes"
            cell.cellButton.tag = indexPath.row
            cell.cellButton.addTarget(self, action: #selector(selectionCellPressed(sender:)), for: .touchUpInside)
            return cell
//        case 12:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSaveChangesButtonCell", for: indexPath) as! TransparentCell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSaveChangesButtonCell", for: indexPath) as! TransparentCell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentFormSelectionCell", for: indexPath) as! IncidentFormSelectionCell
//            cell.cellTitleLabel.text = "test"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 20
        } else if indexPath.row == 4 {
            guard incidentBehaviours != nil else { return 70 }
            if incidentBehaviours!.count > 1 {
                return CGFloat(50 + (incidentBehaviours!.count * 20))
            }
        } else if indexPath.row == 6 {
            guard incidentStaff != nil else { return 70 }
            if incidentStaff!.count > 1 {
                return CGFloat(50 + (incidentStaff!.count * 20))
            }
        } else if indexPath.row == 10 {
            guard incidentPurposes != nil else { return 70 }
            if incidentPurposes!.count > 1 {
                return CGFloat(50 + (incidentPurposes!.count * 20))
            }
        } else if indexPath.row == 11 {
            if incidentNotes.count > 35 {
                let numberExtraLinesNeeded = Int(incidentNotes.count / 35)
                return CGFloat(50 + (numberExtraLinesNeeded * 20))
            }
        } else if indexPath.row == 12 {
            return 125
        }
        return 70
    }
    

}
