//
//  StudentDetailsVC.swift
//  BSA
//
//  Created by Pete Holdsworth on 14/07/2018.
//  Copyright © 2018 Onyx Interactive. All rights reserved.
//

import UIKit

class StudentDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EntityDetailsTextFieldDelegate, ShowEntityClassSelectionDelegate, EntityClassSelectionDelegate, SchoolClassFetchingDelegate {
    

    
    // UI handles:
    @IBOutlet weak var tableView: MaterialTableView!
    
    // Properties:
    var student: Student?
    var id = NSUUID().uuidString
    var studentNumber: Int?
    var firstName: String?
    var lastName: String?
//    var schoolClassNumber: Int?
    var schoolClassId: String?
    var schoolClass: SchoolClass?
    var schoolClassName: String?
    
    var dataService: DataService?
    
    // Configures view when loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // set VC color and title
        view.layer.backgroundColor = Constants.PEOPLE_SCREEN_COLOR.cgColor
        self.navigationItem.title = "Student Details"
        
            // set up table for Staff Member details
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        dataService = DataService()
        dataService?.schoolClassFetchingDelegate = self
        
            // unpack Student object if passed in from parent VC, reload table to include object data, and add 'Delete' button for presented object
        if student != nil {
            id = student!.id
            studentNumber = student!.studentNumber
            firstName = student!.firstName
            lastName = student!.lastName
//            schoolClassNumber = student?.schoolClassNumber
            schoolClassId = student!.schoolClassId
            
            dataService?.getSchoolClass(withId: schoolClassId!)
            
//            schoolClass = Data.getSchoolClass(numbered: schoolClassNumber)
//            schoolClassName = schoolClass?.className
//            tableView.reloadData()
            addDeleteButton()
        }
    }
    
    
    func finishedFetching(schoolClasses: [SchoolClass]) {
        schoolClassName = schoolClass?.className
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    // Sets number of rows in the table of Student details
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // Configures cells in the table of Student details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            // transparent cell used as padding at the top of the table
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsTopPaddingCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
            
            // configure cell for student details Student Number
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Student Number"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
            // if a Staff object was passed in from parent VC, update cell with that object's value
            if studentNumber != nil {
                cell.valueTextField.text = String(studentNumber!)
            }
            
            return cell
            
            // configure cell for student details First Name
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "First Name"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
                // if a Staff object was passed in from parent VC, update cell with that object's value
            if firstName != nil {
                cell.valueTextField.text = firstName!
            }
            
            return cell
            
            // configure cell for student details Last Name
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsTextFieldCell", for: indexPath) as! EntityDetailsTextFieldCell
            cell.titleLabel.text = "Last Name"
            cell.selectionStyle = .none
            cell.entityDetailsTextFieldDelegate = self
            cell.tag = indexPath.row
            
                // if a Staff object was passed in from parent VC, update cell with that object's value
            if lastName != nil {
                cell.valueTextField.text = lastName!
            }
            
            return cell
            
            // configure cell for student details Class
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsSelectionCell", for: indexPath) as! EntityDetailsSelectionCell
            cell.titleLabel.text = "Class"
            cell.valueLabel.text = "Please select..."
            cell.valueLabel.textColor = Constants.GRAY_LIGHT
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            cell.showEntityClassSelectionDelegate = self
            cell.tag = indexPath.row
            
                // if a Staff object was passed in from parent VC, update cell with that object's value
            if schoolClassName != nil {
                cell.valueLabel.text = schoolClassName!
                cell.valueLabel.textColor = .black
            }
            
            return cell
            
            // transparent cell containing the 'Save Changes' button as the last row in the table
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentDetailsSaveChangesButtonCell", for: indexPath) as! TransparentCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    // Sets the height for cells in table of Student details
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10
        } else if indexPath.row == 5 {
            return 125
        } else {
            return 80
        }
    }
    
    
    
    // Adds a configured 'Delete' button to the navigation bar
    func addDeleteButton() {
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(named: "deleteIcon"), for: .normal)
        deleteButton.sizeToFit()
        deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
    }
    
    //  Triggers deletion of the presented entity - and unwinds to parent VC if successful
    @objc func deleteButtonPressed() {
        print("Deleting Student: \n\(String(describing: student!))")
        self.navigationController?.popViewController(animated: true)
    }
    
    

    
    // Sets the Student object's 'First Name', 'Last Name' or 'Student Number' value to the string sent from an edited text field - depending on the cell/textField that was edited by the user (identified using the cell's tag).
    func textFieldChanged(to value: String, for cellTag: Int) {
      
        switch cellTag {
            
        case 1: // Staff Number field edited
            if let studentNumberIntValue = Int(value) {
                studentNumber = studentNumberIntValue
            } else {
                print ("invalid student number")
            }
            
        case 2: // First Name field edited
            firstName = value
            
        case 3: // Last Name field edited
            lastName = value
            
        default : break
        }
    }
    
    // Sets the Student object's schoolClass value to the SchoolClass object sent from a delegated EntityClassSelectionVC. Useful properties (schoolClassNumber and schoolClassName) are also unpacked for convenient use in table values - before reloading the table of Student details
    func didSelect(schoolClass: SchoolClass) {
        self.schoolClass = schoolClass
//        schoolClassNumber = schoolClass.classNumber
        schoolClassName = schoolClass.className
        tableView.reloadData()
    }
    
    // Initiates segue to VC for selecting a class object to assign to the Student. Trigger when the user presses the 'Class' cell in the student details table
    func showClassSelection() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let studentClassSelectionVC = storyboard.instantiateViewController(withIdentifier: "EntityClassSelectionVC") as! EntityClassSelectionVC
        studentClassSelectionVC.entityClassSelectionDelegate = self
        
            // if a schoolClass object has already been assigned to the Student object, pass to the destination/selection VC so that current seletion can be displayed
        if schoolClass != nil {
            studentClassSelectionVC.selectedClass = schoolClass
        }
        
            // perform segue
        self.navigationController?.pushViewController(studentClassSelectionVC, animated: true)
    }


    // Saves changes to Student object details and unwinds to parent VC (first checking to make sure that required values have been given)
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        
        // makue sure a student has been given. If not, present alert to prompt name entry
        guard studentNumber != nil else {
            let alert = UIAlertController(title: "No Student Number Given", message: "Please enter a unique number for the Student", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //------
        
        // makue sure a name has been given. If not, present alert to prompt name entry
        guard firstName != nil && firstName != "" else {
            let alert = UIAlertController(title: "No Name Given", message: "Please enter a First Name for the Student", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //------
 
        // makue sure a name has been given. If not, present alert to prompt name entry
        guard lastName != nil && lastName != "" else {
            let alert = UIAlertController(title: "No Name Given", message: "Please enter a Last Name for the Student", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        // save changes to storage and unwind to parent VC
        
            //  package Staff object and save changes here...
        let updatedStudent = Student(id: self.id, studentNumber: self.studentNumber!, firstName: self.firstName!, lastName: self.lastName!, schoolClassId: NSUUID().uuidString)
//            Student(id: self.id, studentNumber: self.studentNumber!, firstName: self.firstName!, lastName: self.lastName!, schoolClassNumber: self.schoolClassNumber)
        print (updatedStudent)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
