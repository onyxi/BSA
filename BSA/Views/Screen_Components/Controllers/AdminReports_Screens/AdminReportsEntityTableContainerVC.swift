//
//  AdminReportsEntityTableContainerVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 16/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

// Allows the delegate to be notified when a student has been deselected in the table of Students - so that the delegate's 'Whole School' cell's UISwitch can beset to 'off'.
protocol WholeSchoolDeselectionDelegate {
    func deselectWholeSchool()
}

// Allows the delegate to be notified when a selection of Student objects has been confirmed and the user has requested to see reports containing only the data for those selected Students.
protocol ViewReportsForSelectionDelegate {
    func viewReportsFor(selection: [Student])
}

class AdminReportsEntityTableContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EntityGroupSwitchDelegate, IndividualEntitySwitchDelegate {
 
    
    // UI handles:
    @IBOutlet weak var tableView: UITableView!
    
    // Properties:
    var allEntities = [Any]()
    var selectedSchoolClasses = [SchoolClass]()
    var selectedStudents = [Student]()
    var schoolClassCellIndexes = [Int]()
    var wholeSchoolDeselectionDelegate: WholeSchoolDeselectionDelegate!
    var viewReportsForSelectionDelegate: ViewReportsForSelectionDelegate!
    
    
    // Configure view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()

            // set up table for Whole School selection cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    
    // Unpacks the objects passed in from the parent VC to be used to populate the table view. Each SchoolClass/Student is added to a single array of generic 'entities', and the index/position of the SchoolClass objects is recorded (in the 'schoolClassCellIndexes' array) so that SchoolClass cells can be identified in the table view.
    func unpackClassesWithStudents(classesWithStudents: [(SchoolClass, [Student])]?) {
        guard classesWithStudents != nil else { return }
        var entityIndex = 0
        for (schoolClass, students) in classesWithStudents! {
            allEntities.append(schoolClass)
            schoolClassCellIndexes.append(entityIndex)
            entityIndex += 1
            for student in students {
                allEntities.append(student)
                entityIndex += 1
            }
        }
        tableView.reloadData()
    }

    
    // Sets number of rows in the table of SchoolClasses and Students
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEntities.count + 1
    }
    
    // Configures cells in the table of SchoolClasses and Students
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // configure cells to represent the different SchoolClass objects
        if schoolClassCellIndexes.contains(indexPath.row) {
            let schoolClass = allEntities[indexPath.row] as! SchoolClass
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReportsEntityGroupCell", for: indexPath) as! AdminReportsEntityGroupCell
            cell.titleLabel.text = schoolClass.className
            cell.tag = indexPath.row
            cell.entityGroupSwitchDelegate = self
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
                // set state of the cell's UISwitch to reflect whether the SchoolClass is currently selected
            if selectedSchoolClasses.contains(schoolClass) {
                if !cell.selectionSwitch.isOn {
                    cell.selectionSwitch.setOn(true, animated: false)
                }
            } else {
                if cell.selectionSwitch.isOn {
                    cell.selectionSwitch.setOn(false, animated: false)
                }
            }
            return cell
            
            // configure cell for 'View Reports' button - to confirm selection has been made
        } else if indexPath.row == allEntities.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReportsViewReportsButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell

            // configure cells that represent the different Student objects
        } else {
            let student = allEntities[indexPath.row] as! Student
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReportsIndividualEntityCell", for: indexPath) as! AdminReportsIndividualEntityCell
            cell.titleLabel.text = "\(student.firstName!) \(student.lastName!)"
            cell.tag = indexPath.row
            cell.individualEntitySwitchDelegate = self
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            
                // set state of the cell's UISwitch to reflect whether the Student is currently selected
            if selectedStudents.contains(student) {
                if !cell.selectionSwitch.isOn {
                    cell.selectionSwitch.setOn(true, animated: true)
                }
            } else {
                if cell.selectionSwitch.isOn {
                    cell.selectionSwitch.setOn(false, animated: true)
                }
            }
            return cell
        }
    }
    
    // Sets the height for cells in the table of SchoolClasses and Students
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == allEntities.count {
            return 125
        } else {
            return 70
        }
    }
    
    
    // Sets all Student (and SchoolClass) cells in the table view to reflect the state of the 'Whole School' - which is in the container view's parent VC. The tableView's data is then reloaded to ensure UISwitches reflect the objects contained in the selection arrays
    func selectionSwitchChangedForWholeSchool(to value: Bool) {
        // if 'whole school' cell set to 'false', remove all objects from the arrays of selected Students/SchoolClasses
        if value == false {
            selectedSchoolClasses.removeAll()
            selectedStudents.removeAll()
            
            // if set to 'true' add Students/SchoolClass objects to arrays of selected Students/SchoolClasses (only if they are not already contained in those arrays)
        } else {
            for entity in allEntities {
                if let schoolClass = entity as? SchoolClass {
                    if !selectedSchoolClasses.contains(schoolClass) {
                        selectedSchoolClasses.append(schoolClass)
                    }
                } else if let student = entity as? Student {
                    if !selectedStudents.contains(student) {
                        selectedStudents.append(student)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    
    // Adds or removes Students or SchoolClasses (including all of the class' associated Students) to/from the selected Students/SchoolClass arrays when the user's sets the corresponding cell's UISwitch in the table view. Students and SchoolClasses are only added to their respective selection array if they are not already contained there. The tableView's data is then reloaded to ensure UISwitches reflect the objects contained in the selection arrays
    func selectionSwitchChangedValueFor(cellWithTag: Int, to value: Bool) {
        
        // if the user has changed a SchoolClass' UISwitch, add/remove the corresponding SchoolClass object from selection array (and all associated Students to selection arrays)
        if let schoolClass = allEntities[cellWithTag] as? SchoolClass {
            
            // add/remove SchoolClass from selection array (and notify delegate that the 'whole-school' cell should be set to 'off' (false)
            if !selectedSchoolClasses.contains(schoolClass) && value == true {
                selectedSchoolClasses.append(schoolClass)
            } else if selectedSchoolClasses.contains(schoolClass) && value == false {
                let index = selectedSchoolClasses.index(of: schoolClass)
                selectedSchoolClasses.remove(at: index!)
                wholeSchoolDeselectionDelegate.deselectWholeSchool()
            }
            
            // Identify all Students associated with the SchoolClass and add/remove them from selection array
            for entity in allEntities {
                guard let student = entity as? Student else { continue }
//                guard student.schoolClassNumber == schoolClass.classNumber else { continue }// {
            guard student.schoolClassId == schoolClass.id else { continue }// {
                if !selectedStudents.contains(student) && value == true {
                    selectedStudents.append(student)
                } else if selectedStudents.contains(student) && value == false {
                    let index = selectedStudents.index(of: student)
                    selectedStudents.remove(at: index!)
                }
            }
            
            // if the user has changed a Student UISwitch, add/remove the corresponding Student object from selection array
        } else if let student = allEntities[cellWithTag] as? Student {
            
            // add Student to selection array
            if !selectedStudents.contains(student) && value == true {
                selectedStudents.append(student)
                
                // remove Student from selection array, set the selection of the cell representing the SchoolClass that the Student is associated with to false (all Student must be selected for a SchoolClass cell's UISwitch to be set to 'On'), (and notify delegate that the 'whole-school' cell should be set to 'off' (false)
            } else if selectedStudents.contains(student) && value == false {
                let studentIndex = selectedStudents.index(of: student)
                selectedStudents.remove(at: studentIndex!)
                for schoolClass in selectedSchoolClasses {
//                    if schoolClass.classNumber == student.schoolClassNumber {
                    if schoolClass.id == student.schoolClassId {
                        let index = selectedSchoolClasses.index(of: schoolClass)!
                        selectedSchoolClasses.remove(at: index)
                    }
                }
                wholeSchoolDeselectionDelegate.deselectWholeSchool()
                
            }
        }
        tableView.reloadData()
    }
    
    
    
    // Notifies the delegate that the selection has been confirmed and passes in the current selection of Student objects so that reports can be filtered to show only data for these Students
    @IBAction func viewReportsButtonPressed(_ sender: Any) {
        viewReportsForSelectionDelegate.viewReportsFor(selection: selectedStudents)
    }
    
}
